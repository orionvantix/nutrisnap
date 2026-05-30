# NutriSnap - AI Macro Tracker

I built this because I got tired of guessing what I'm eating. Most calorie apps make you search a database and type everything manually. I wanted to just point my phone at food and get an answer.

## What it does

**AI Food Scanner** — photo or upload, it estimates calories and macros for everything in the image. If there are 6 apples it counts all 6, not just one. Tap + or − to correct the count if it's off.

**Barcode Lookup** — type any barcode and it pulls real nutrition data from Open Food Facts.

**Macro Calculator** — enter your stats and goal, get your daily calorie and macro targets. Shows maintenance, goal plan, and what maintenance looks like once you hit your target weight.

**Food Log** — everything you add shows running totals for the day. Saves automatically so it survives a refresh.

**Progress Tracker** — log your weight and watch the chart.

## Stack

Single HTML file. GPT-4o Vision for food photos via a Flask proxy on the VPS (so the API key never touches the browser). Open Food Facts for barcodes. Hostinger VPS, Traefik, HTTPS, GitHub Actions for auto-deploy.

## Live

https://cdn.srv1151834.hstgr.cloud/nutrisnap.html

## CI/CD

Push nutrisnap.html to main, it's live in about 11 seconds.

## What's next

User accounts for cross-device sync and weight input after AI scan for more accurate results.
