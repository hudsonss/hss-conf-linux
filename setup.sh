#!/bin/bash

# Função para identificar o sistema operacional
get_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    else
        echo "unknown"
    fi
}

# Função para atualizar o sistema
update_system() {
    echo "Atualizando o sistema..."
    case "$OS" in
        fedora)
            sudo dnf update -y
            ;;
        arch)
            sudo pacman -Syu --noconfirm
            ;;
        debian | ubuntu)
            sudo apt update && sudo apt upgrade -y
            ;;
        *)
            echo "Sistema operacional não suportado."
            ;;
    esac
}

# Função para instalar pacotes
install_packages() {
    echo "Instalando pacotes necessários..."
    case "$OS" in
        fedora)
            sudo dnf install -y git curl wget neovim unzip
            ;;
        arch)
            sudo pacman -S --noconfirm git curl wget neovim unzip
            ;;
        debian | ubuntu)
            sudo apt install -y git curl wget neovim unzip
            ;;
        *)
            echo "Sistema operacional não suportado."
            ;;
    esac
}

# Diretório para instalar as fontes
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Função para baixar e instalar uma fonte do Nerd Fonts
install_font() {
    local font_name=$1
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.zip"
    local temp_zip="/tmp/${font_name}.zip"

    echo "Baixando e instalando a fonte: $font_name..."
    wget -q -O "$temp_zip" "$font_url"
    if [ $? -eq 0 ]; then
        unzip -o -qq "$temp_zip" -d "$FONT_DIR" > /dev/null
        rm "$temp_zip"
        echo "Fonte $font_name instalada com sucesso!"
    else
        echo "Erro ao baixar a fonte $font_name. Verifique sua conexão."
    fi
}

# Função para atualizar o cache de fontes
update_font_cache() {
    echo "Atualizando o cache de fontes..."
    if fc-cache -fv > /dev/null 2>&1; then
        echo "Cache de fontes atualizado com sucesso!"
    else
        echo "Falha ao atualizar o cache de fontes. Verifique os erros."
    fi
}

# Função para escolher e instalar fontes
install_fonts_menu() {
    local fonts=("JetBrainsMono" "Hack" "FiraCode" "Meslo" "SourceCodePro" "Terminus" "Monoid" "Noto" "UbuntuMono" "DroidSansMono" "Hermit" "IBMPlexMono" "Inconsolata" "LiberationMono" "RobotoMono")
    echo "Escolha as fontes que deseja instalar:"
    for i in "${!fonts[@]}"; do
        printf "%2d) %s\n" $((i+1)) "${fonts[i]}"
    done
    echo " A) Instalar todas as fontes"
    echo " Q) Sair"
    read -p "Digite sua escolha (número ou 'A' para todas): " choice

    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#fonts[@]}" ]; then
        install_font "${fonts[$((choice-1))]}"
    elif [[ "$choice" == "A" || "$choice" == "a" ]]; then
        for font in "${fonts[@]}"; do
            install_font "$font"
        done
    elif [[ "$choice" == "Q" || "$choice" == "q" ]]; then
        echo "Saindo da instalação de fontes."
        return
    else
        echo "Escolha inválida. Tente novamente."
        install_fonts_menu
    fi
}

# Função para personalizar o terminal
# Função para customizar o terminal com o bashrc configurado
customize_terminal() {
    echo "Baixando o bashrc personalizado..."

    # URL do seu arquivo bashrc configurado
    BASHRC_URL="https://seu-repositorio-ou-url.com/bashrc"

    # Baixar o arquivo bashrc
    wget -O ~/.bashrc "$BASHRC_URL"
    if [ $? -eq 0 ]; then
        echo "bashrc personalizado baixado com sucesso!"
    else
        echo "Erro ao baixar o bashrc. Verifique a URL."
        return
    fi

    # Aplicar as mudanças
    source ~/.bashrc
    echo "Terminal personalizado com sucesso!"
}


# Função para executar todas as ações
run_all() {
    update_system
    install_packages
    install_fonts_menu
    customize_terminal
}

# Detectar o sistema operacional
OS=$(get_os)

echo "Sistema detectado: $OS"

# Menu interativo
while true; do
    echo "O que você gostaria de fazer?"
    echo "1) Atualizar o sistema"
    echo "2) Instalar pacotes necessários"
    echo "3) Instalar fontes personalizadas"
    echo "4) Personalizar o terminal"
    echo "5) Executar todas as ações"
    echo "6) Sair"
    read -p "Escolha uma opção (1-6): " option

    case $option in
        1)
            update_system
            ;;
        2)
            install_packages
            ;;
        3)
            install_fonts_menu
            ;;
        4)
            customize_terminal
            ;;
        5)
            run_all
            ;;
        6)
            echo "Saindo do script. Até mais!"
            exit 0
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            ;;
    esac
done
