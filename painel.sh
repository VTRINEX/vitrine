#!/bin/bash
FILE="produtos.json"
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
            read -p "Selo (Ex: Oferta, Novo, ou de um ENTER pra vazio): " selo
            read -p "Link da Imagem: " img
            read -p "Link de Afiliado (pra onde o botão Comprar vai): " link
            id=$(date +%s)
            
            jq --arg id "$id" --arg name "$nome" --arg cat "$cat" --argjson price "${preco:-0}" --arg img "$img" --arg link "$link" --arg badge "$selo" \
            '. += [{"id": $id, "name": $name, "category": $cat, "price": $price, "imageUrl": $img, "affiliateLink": $link, "badge": $badge}]' "$FILE" > tmp.json && mv tmp.json "$FILE"
            
            echo -e "\e[32m✔ Produto injetado no banco local!\e[0m"
            sleep 2
            ;;
        2)
            echo ""
            jq -r '.[] | "[\(.id)] \(.name) - R$ \(.price)"' "$FILE"
            echo ""
            read -p "Digite o número ID (entre colchetes) do produto para aniquilar: " del_id
            jq --arg id "$del_id" 'del(.[] | select(.id == $id))' "$FILE" > tmp.json && mv tmp.json "$FILE"
            echo -e "\e[31m✔ Produto desintegrado com sucesso!\e[0m"
            sleep 2
            ;;
        3)
            echo ""
            jq -r '.[] | "-> \(.name) (\(.category)) | R$ \(.price)"' "$FILE"
            echo ""
            read -p "Aperte ENTER para voltar ao menu..."
            ;;
        4)
            echo -e "\e[35mIniciando protocolo de lançamento orbital...\e[0m"
            git add index.html produtos.json painel.sh
            git commit -m "Atualizacao automatica via Terminal VTRINEX"
            git push origin main
            echo -e "\e[32m✔ Código enviado! A Microsoft está atualizando os servidores. Aguarde 2 minutos e atualize o site.\e[0m"
            sleep 4
            ;;
        5)
            clear
            exit 0
            ;;
        *)
            echo "Opção inválida, tenta de novo."
            sleep 1
            ;;
    esac
done
