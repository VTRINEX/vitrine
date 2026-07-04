#!/usr/bin/bash
CREDS="$HOME/.vitrine_creds"
if [ -f "$CREDS" ]; then
    source "$CREDS"
else
    clear && echo -e "\033[1;33m🔐 SALVANDO CREDENCIAIS BLINDADAS (APENAS 1ª VEZ)\033[0m"
    read -p " 👉 Usuário do GitHub: " GH_USER
    read -p " 👉 Nome do repositório (Ex: vitrine): " GH_REPO
    read -p " 👉 Token (PAT ghp_...): " GH_TOKEN
    echo "GH_USER=\"$GH_USER\"" > "$CREDS" && echo "GH_REPO=\"$GH_REPO\"" >> "$CREDS" && echo "GH_TOKEN=\"$GH_TOKEN\"" >> "$CREDS"
    chmod 600 "$CREDS"
fi
git config --global user.name "Admin A52" && git config --global user.email "admin@vitrine.local"
rm -rf .git && git init > /dev/null 2>&1 && git branch -M main > /dev/null 2>&1
git remote add origin "https://${GH_USER}:${GH_TOKEN}@github.com/${GH_USER}/${GH_REPO}.git"
git add . && git commit -m "Auto Deploy A52" > /dev/null 2>&1
echo -e "\n\033[1;33m📤 Sincronizando com a nuvem do GitHub...\033[0m"
if git push -u origin main --force > /dev/null 2>&1; then
    echo -e "\033[1;32m✅ VITRINE ATUALIZADA COM SUCESSO!\033[0m"
    echo -e "👉 Link Oficial: \033[1;36mhttps://${GH_USER}.github.io/${GH_REPO}/\033[0m\n"
else
    echo -e "\033[1;31m❌ Erro no envio. Apague as credenciais com 'rm ~/.vitrine_creds' e tente de novo.\033[0m"
fi
