# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "/home/hudsonss/.local/bin:/home/hudsonss/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin" =~ "/home/hudsonss/.local/bin:/home/hudsonss/bin:" ]]; then
    PATH="/home/hudsonss/.local/bin:/home/hudsonss/bin:/home/hudsonss/.local/bin:/home/hudsonss/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "" ]; then
            . ""
        fi
    done
fi
unset rc

# Prompt personalizado
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias bat='bat --theme=ansi-dark'
alias up='sudo dnf update -y'
alias bashc='vi ~/.bashrc'
alias install='sudo dnf install'
alias vi='nvim'

OS_ICON=

get_folder_icon() {
    case "$PWD" in
        */Desktop)    echo " " ;;  # Ícone para a área de trabalho
        */Documentos)  echo "󱔗" ;;  # Ícone para documentos
        */Downloads)  echo " " ;;  # Ícone para downloads
        */Musicas)      echo " " ;;  # Ícone para música
        */Imagens)   echo " " ;;  # Ícone para imagens
        */Videos)     echo " " ;;  # Ícone para vídeos
        */Projects)   echo " " ;;  # Ícone para projetos
        */Modelos)   echo "" ;;  # Ícone para projetos
        */.config)    echo " " ;;  # Ícone para configurações
        */.local)     echo " " ;;  # Ícone para dados locais
        */.cache)     echo " " ;;  # Ícone para cache
        *)            echo "" ;;   # Ícone genérico para outros diretórios
    esac
}

# Função para exibir o nome da branch atual do Git, se estiver em um repositório Git
parse_git_branch() {
    git rev-parse --is-inside-work-tree &>/dev/null
    if [ $? -eq 0 ]; then
        branch=$(git branch --show-current)
        echo " $branch"  # Ícone e nome da branch
    fi
}


PS1="\[\033[38;1;83m\]$OS_ICON \u\[\033[0m\] \[\033[38;5;123m\]❯\[\033[0m\]\[\033[38;5;159m\] \$(get_folder_icon) \w\[\033[0m\]\[\033[38;5;226m\] \$(parse_git_branch)\[\033[0m\]\[\033[38;5;83m\]❯ $\[\033[0m\] "

# Atualize o PS1 para chamar parse_git_branch
# PS1="\[\033[38;1;83m\]$OS_ICON \u\[\033[0m\] \[\033[38;5;123m\]❯\[\033[0m\]\[\033[38;5;159m\] \$(get_folder_icon) \w\[\033[0m\]\[\033[38;5;226m\] \$(parse_git_branch)\[\033[0m\]\[\033[38;5;83m\]❯ $\[\033[0m\] "
