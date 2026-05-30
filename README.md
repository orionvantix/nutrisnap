# NutriSnap

I built this because I got tired of guessing what I'm eating. Most calorie apps make you search a database and type everything manually. I wanted to just point my phone at food and get an answer.

## What it does

**AI Food Scanner:** take a photo or upload one, and it estimates the calories and macros for everything visible. If there are 6 apples it calculates for all 6, not just one. You can tap + or − to fix the count if it's off.

**Barcode Lookup:** type any barcode and it pulls real nutrition data from Open Food Facts.

**Macro Calculator:** enter your weight, height, age, and goal and it gives you daily calorie and macro targets. Shows your maintenance calories, your goal plan, and what maintenance looks like once you reach your target.

**Food Log:** everything you add shows running totals for the day and saves automatically so it's still there after a refresh.

**Progress Tracker:** log your weight daily and see a chart over time.

## Stack

Single HTML file. GPT-4o Vision for food photos via a Flask proxy on the VPS so the API key never touches the browser. Open Food Facts for barcodes. Hostinger VPS, Traefik, HTTPS, GitHub Actions for auto-deploy.

## Live

https://cdn.srv1151834.hstgr.cloud/nutrisnap.html

## CI/CD

Push nutrisnap.html to main, it's live in about 11 seconds.

## What's next

User accounts for cross-device sync and weight input after AI scan for more accurate results.
