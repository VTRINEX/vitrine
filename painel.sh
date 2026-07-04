#!/bin/bash
FILE="produtos.json"
[ ! -f "$FILE" ] && echo "[]" > "$FILE"

while true; do
    clear
    echo -e "\e[34m======================================\e[0m"
    echo -e "\e[1;33m  VTRINEX - TERMINAL DE CONTROLE\e[0m"
    echo -e "\e[34m======================================\e[0m"
    echo -e "1) \e[32mAdicionar Produto\e[0m"
    echo -e "2) \e[31mRemover Produto\e[0m"
    echo -e "3) \e[36mVer Produtos Atuais\e[0m"
    echo -e "4) \e[1;35m🔥 PUBLICAR MUDANÇAS NA INTERNET 🔥\e[0m"
    echo -e "5) Sair"
    echo -e "\e[34m======================================\e[0m"
    read -p "Escolha a opção (1-5): " opcao

    case $opcao in
        1)
            echo ""
            read -p "Nome do Produto: " nome
            read -p "Categoria (Eletrônicos/Celulares/Casa/Moda): " cat
            read -p "Preço (Ex: 199.90 - use ponto, não vírgula): " preco
            read -p "Selo (Ex: Oferta, Novo, ou ENTER pra vazio): " selo
            read -p "Link da Imagem: " img
            read -p "Link de Afiliado (pra onde o botão Comprar vai): " link
            id=$(date +%s)
            
            jq --arg id "$id" --arg name "$nome" --arg cat "$cat" --argjson price "${preco:-0}" --arg img "$img" --arg link "$link" --arg badge "$selo" \
            '. += [{"id": $id, "name": $name, "category": $cat, "price": $price, "imageUrl": $img, "affiliateLink": $link, "badge": $badge}]' "$FILE" > tmp.json && mv tmp.json "$FILE"
            
            echo -e "\e[32m✔ Produto armazenado no banco local!\e[0m"
            sleep 2
            ;;
        2)
            echo ""
            jq -r '.[] | "[\(.id)] \(.name) - R$ \(.price)"' "$FILE"
            echo ""
            read -p "Digite o número ID (entre colchetes) do produto para apagar: " del_id
            jq --arg id "$del_id" 'del(.[] | select((.id | tostring) == $id))' "$FILE" > tmp.json && mv tmp.json "$FILE"
            echo -e "\e[31m✔ Produto varrido do mapa!\e[0m"
            sleep 2
            ;;
        3)
            echo ""
            jq -r '.[] | "-> \(.name) (\(.category)) | R$ \(.price)"' "$FILE"
            echo ""
            read -p "Aperte ENTER para voltar..."
            ;;
        4)
            echo -e "\e[35mIniciando protocolo de fusão estática...\e[0m"
            
            # Pega o arquivo template e injeta o JSON cirurgicamente na tag __DATA__
            awk 'NR==FNR {a[NR]=$0; n=NR; next} /__DATA__/ {for(i=1; i<=n; i++) print a[i]; next} 1' "$FILE" template.html > index.html
            
            git add template.html index.html produtos.json painel.sh
            git commit -m "Deploy Nativo VTRINEX: $(date +'%Y-%m-%d %H:%M:%S')"
            git push origin main
            
            echo -e "\e[32m✔ Fusão concluída e enviada! O código final foi reescrito. Aguarde 2 min e atualize o site.\e[0m"
            sleep 4
            ;;
        5)
            clear
            exit 0
            ;;
        *)
            echo "Opção inválida."
            sleep 1
            ;;
    esac
done
