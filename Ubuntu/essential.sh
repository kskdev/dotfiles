#!/bin/sh

sudo apt update && sudo apt upgrade -y

sudo apt install -y git
sudo apt install -y unzip
sudo apt install -y build-essential
sudo apt install -y software-properties-common
sudo apt install -y curl

sudo apt install -y zsh
sudo apt install -y tmux
sudo apt install -y axel
sudo apt install -y htop
sudo apt install -y tree

sudo apt autoremove -y

# Set Directory name Englishization
LANG=C xdg-user-dirs-gtk-update

# Change login shell from bash to zsh (required password)
chsh -s $(which zsh)
exec $SHELL -l

