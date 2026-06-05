import os
import re
import json
import time
from functools import wraps
from collections import defaultdict

from flask import Flask, request, jsonify
from openai import OpenAI

app = Flask(__name__)
client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])

PROXY_SECRET = os.environ["NUTRISNAP_SECRET"]
ALLOWED_ORIGIN = os.environ.get("ALLOWED_ORIGIN", "https://cdn.srv1151834.hstgr.cloud")

# Rate limiting: 20 requests per IP per minute
rate_store = defaultdict(list)
RATE_LIMIT = 20
RATE_WINDOW = 60

ANALYSIS_PROMPT = """You are a precise nutrition estimator. Look very carefully at this image:
1. COUNT every individual item you can see (dates, apples, pieces, etc.)
2. ESTIMATE the volume/portion for bulk foods (rice, pasta, etc.)
3. Return TOTAL macros for the ENTIRE portion visible, not per 100g

Respond ONLY with valid JSON, no markdown:
{"food":"exact description with quantity","calories":number,"protein_g":number,"fat_g":number,"carbs_g":number,"confidence":"low/medium/high","note":"what you counted and how you estimated"}"""


def rate_limited(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        ip = request.remote_addr
        now = time.time()
        rate_store[ip] = [t for t in rate_store[ip] if now - t < RATE_WINDOW]
        if len(rate_store[ip]) >= RATE_LIMIT:
            return jsonify({"error": "rate limit exceeded"}), 429
        rate_store[ip].append(now)
        return f(*args, **kwargs)
    return decorated


def require_secret(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if request.method == "OPTIONS":
            return f(*args, **kwargs)
        token = request.headers.get("X-Nutrisnap-Key", "")
        if token != PROXY_SECRET:
            return jsonify({"error": "unauthorized"}), 401
        return f(*args, **kwargs)
    return decorated


@app.after_request
def add_cors_headers(response):
    response.headers["Access-Control-Allow-Origin"] = ALLOWED_ORIGIN
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, X-Nutrisnap-Key"
    response.headers["Access-Control-Allow-Methods"] = "POST, OPTIONS"
    return response


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"}), 200


@app.route("/analyze", methods=["POST", "OPTIONS"])
@require_secret
@rate_limited
def analyze():
    if request.method == "OPTIONS":
        return "", 204

    data = request.get_json()
    if not data:
        return jsonify({"error": "invalid request"}), 400

    image_data = data.get("image", "")
    if not image_data or not image_data.startswith("data:image/"):
        return jsonify({"error": "invalid image data"}), 400

    try:
        response = client.chat.completions.create(
            model="gpt-4o",
            max_tokens=400,
            messages=[
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "image_url",
                            "image_url": {"url": image_data, "detail": "high"},
                        },
                        {"type": "text", "text": ANALYSIS_PROMPT},
                    ],
                }
            ],
        )

        raw = response.choices[0].message.content.strip()
        raw = re.sub(r"```[a-z]*|```", "", raw).strip()
        result = json.loads(raw)

        # Sanitize and validate response schema
        safe_result = {
            "food": str(result.get("food", "Unknown"))[:200],
            "calories": max(0, int(result.get("calories", 0))),
            "protein_g": max(0, float(result.get("protein_g", 0))),
            "fat_g": max(0, float(result.get("fat_g", 0))),
            "carbs_g": max(0, float(result.get("carbs_g", 0))),
            "confidence": str(result.get("confidence", "medium")),
            "note": str(result.get("note", ""))[:300],
        }
        return jsonify(safe_result)

    except (json.JSONDecodeError, KeyError, ValueError):
        return jsonify({"error": "analysis failed"}), 500
    except Exception:
        return jsonify({"error": "internal server error"}), 500


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8766))
    app.run(host="0.0.0.0", port=port)
