# NutriSnap — AI Macro Tracker

I built this because I got tired of trying to figure out what I'm actually eating.

Most calorie apps make you search through a database, manually type everything, and guess portion sizes. I wanted something where I could just point my phone at food and get an answer. So I built it.

---

## What it does

**AI Food Scanner** — take a photo or upload one, and it tells you the calories, protein, fat, and carbs for what's in the image. It counts the items too (like if there are 6 apples on a plate, it estimates for all 6, not just one). You can tap + or − to correct the count if it's off.

**Barcode Lookup** — scan or type any barcode from a packaged food and it pulls the real nutrition data from the Open Food Facts database.

**Macro Calculator** — enter your weight, height, age, and goal, and it calculates your daily calorie and macro targets using the Mifflin-St Jeor formula. Shows you three plans: maintenance, your goal plan, and what maintenance looks like once you hit your goal weight.

**Daily Food Log** — everything you add goes into today's log with running totals. The log saves automatically so it's still there if you close the tab or refresh.

**Progress Tracker** — log your weight daily and it shows a chart of your progress over time.

---

## Stack

- Single HTML file — no framework, no build step, no dependencies to install
- GPT-4o Vision for food photo analysis (via a Flask proxy on the VPS — the API key never touches the browser)
- Open Food Facts API for barcode lookups (free, no key needed)
- Hosted on Hostinger VPS behind Traefik with HTTPS
- GitHub Actions for CI/CD — push to main and it deploys automatically in about 11 seconds

---

## Why a proxy server?

You can't call the OpenAI API directly from the browser — the key would be visible to anyone who opens DevTools. So there's a small Flask server running on the VPS that handles the API call server-side and just returns the result. The HTML talks to that endpoint instead.

---

## Live app

https://cdn.srv1151834.hstgr.cloud/nutrisnap.html

Works on phone too — just open the link in Safari or Chrome.

---

## How the CI/CD works

```
Edit nutrisnap.html → git push → GitHub Actions → SCP to VPS → live
```

The workflow only triggers when `nutrisnap.html` changes, so pushing other files doesn't kick off a deploy. Total time from push to live is around 11 seconds.

---

## What's next

- User accounts so the food log syncs across devices
- Weight input after AI scan for more accurate macro calculation
- TikTok is already full of people filming their meals — this could actually be useful
