#!/bin/sh

# ::::::::::::::::::::::::::::::::::::::::
# 環境構築 on Ubuntu
# ::::::::::::::::::::::::::::::::::::::::


# --- install apps
echo -e "\e[31m ::: 1. Install apps via apt \e[m"
cd ./AppInit/
sh init_ubuntu.sh
cd ../

# --- setup tmux configs
echo -e "\e[31m ::: 2. Setup tmux configs \e[m"
cd ./Tmux/
zsh make_link.sh
cd ../

# --- setup zsh configs
echo -e "\e[31m ::: 3. Setup zsh configs \e[m"
cd ./Shell/
zsh zshrc_init.sh
cd ../

# --- setup vim configs
echo -e "\e[31m ::: 4. Setup vim configs \e[m"
cd ./Vim/
zsh install_vim_zsh_alone.sh
cd ../

# --- setup others settings.
echo -e "\e[31m ::: Ex. Setup others configs \e[m"
echo "input password for changing login shell."
chsh -s $(which zsh)
echo "reload .zshrc"
source ~/.zshrc

echo " "
echo " "
echo -e "\e[31m Done setup. hello myworld. \e[m"
echo ""
echo " "
echo " "

