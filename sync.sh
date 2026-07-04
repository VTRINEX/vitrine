#!/usr/bin/bash
source "$HOME/.vitrine_creds"
cd "$HOME/vitrine_premium/public"
git config user.name "Admin A52"
git config user.email "admin@vitrine.local"
git add .
git commit -m "Auto-Sync A52 - $(date '+%d/%m %H:%M:%S')" > /dev/null 2>&1
git push "https://${GH_USER}:${GH_TOKEN}@github.com/${GH_USER}/${GH_REPO}.git" main --force
