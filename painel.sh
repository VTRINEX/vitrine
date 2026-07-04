#!/bin/bash
FILE="produtos.json"
[ ! -f "$FILE" ] && echo "[]" > "$FILE"

while true; do
    clear
    echo -e "\e[34m======================================\e[0m"
    echo -e "\e[1;33m  VTRINEX - TERMINAL PARA PREGUIÇOSOS\e[0m"
    echo -e "\e[34m======================================\e[0m"
    echo -e "1) \e[32mAdicionar Produto\e[0m"
    echo -e "2) \e[31mRemover Produto (Fácil)\e[0m"
    echo -e "3) \e[36mVer Produtos Atuais\e[0m"
    echo -e "4) \e[1;35m🔥 PUBLICAR MUDANÇAS NA INTERNET 🔥\e[0m"
    echo -e "5) Sair"
    echo -e "\e[34m======================================\e[0m"
    read -p "Escolha a opção (1-5): " opcao

    case $opcao in
        1)
            echo ""
            read -p "Nome do Produto: " nome
            
            echo -e "\nCategorias:"
            echo "1) Eletrônicos | 2) Celulares | 3) Casa | 4) Moda"
            read -p "Escolha o número (1-4): " cat_opt
            case $cat_opt in
                1) cat="Eletrônicos";;
                2) cat="Celulares";;
                3) cat="Casa";;
                4) cat="Moda";;
                *) cat="Outros";;
            esac
            
            read -p "Preço (Ex: 199.90 ou 199,90): " preco
            preco="${preco//,/.}"
            
            echo -e "\nSelos:"
            echo "1) Oferta | 2) Novo | 3) Mais Vendido | 4) Nenhum"
            read -p "Escolha o número (1-4): " selo_opt
            case $selo_opt in
                1) selo="Oferta";;
                2) selo="Novo";;
                3) selo="Mais Vendido";;
                *) selo="";;
            esac
            
            read -p "Link da Imagem: " img
            read -p "Link de Afiliado (Destino da compra): " link
            id=$(date +%s)
            
            jq --arg id "$id" --arg name "$nome" --arg cat "$cat" --argjson price "${preco:-0}" --arg img "$img" --arg link "$link" --arg badge "$selo" \
            '. += [{"id": $id, "name": $name, "category": $cat, "price": $price, "imageUrl": $img, "affiliateLink": $link, "badge": $badge}]' "$FILE" > tmp.json && mv tmp.json "$FILE"
            
            echo -e "\e[32m✔ Produto armazenado com mínimo esforço!\e[0m"
            sleep 2
            ;;
        2)
            echo ""
            total=$(jq '. | length' "$FILE")
            if [ "$total" -eq 0 ]; then
                echo -e "\e[31mA vitrine já está completamente vazia.\e[0m"
                sleep 2
                continue
            fi

            # Lista os produtos com números sequenciais fáceis (1, 2, 3...)
            jq -r 'to_entries | .[] | "[\(.key + 1)] \(.value.name) - R$ \(.value.price)"' "$FILE"
            echo ""
            read -p "Digite apenas o NÚMERO (1, 2, 3...) para apagar: " del_idx
            
            # Checa se o usuário digitou um número válido
            if [[ "$del_idx" =~ ^[0-9]+$ ]] && [ "$del_idx" -ge 1 ] && [ "$del_idx" -le "$total" ]; then
                idx=$((del_idx-1))
                jq "del(.[$idx])" "$FILE" > tmp.json && mv tmp.json "$FILE"
                echo -e "\e[31m✔ Produto eliminado sem precisar copiar código gigante!\e[0m"
            else
                echo -e "\e[31mErro: Isso não é um número válido da lista.\e[0m"
            fi
            sleep 2
            ;;
        3)
            echo ""
            jq -r 'to_entries | .[] | "[\(.key + 1)] \(.value.name) (\(.value.category)) | R$ \(.value.price)"' "$FILE"
            echo ""
            read -p "Aperte ENTER para voltar ao menu..."
            ;;
        4)
            echo -e "\e[35mIniciando protocolo de fusão estática...\e[0m"
            awk 'NR==FNR {a[NR]=$0; n=NR; next} /__DATA__/ {for(i=1; i<=n; i++) print a[i]; next} 1' "$FILE" template.html > index.html
            
            git add template.html index.html produtos.json painel.sh
            git commit -m "Deploy Nativo VTRINEX: $(date +'%Y-%m-%d %H:%M:%S')"
            git push origin main
            
            echo -e "\e[32m✔ Concluído! O site imune a cache está online. (Aguarde 2 minutos)\e[0m"
            sleep 4
            ;;
        5)
            clear
            exit 0
            ;;
        *)
            echo "Opção inválida ou erro na matriz."
            sleep 1
            ;;
    esac
done
