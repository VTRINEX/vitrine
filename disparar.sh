#!/usr/bin/bash
echo "Enviando vitrine para a conta VTRINEX no GitHub..."
if git push -u origin main --force; then
    echo "SUCESSO ABSOLUTO! Site publicado na nuvem!"
    echo "URL Oficial: https://VTRINEX.github.io/vitrine/"
else
    echo "FALHA: O GitHub revogou automaticamente seu Token por ter sido exposto no chat."
    echo "Solução: Gere um novo Token no GitHub e rode ./arrumar_token.sh no terminal."
fi
