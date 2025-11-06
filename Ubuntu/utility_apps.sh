#!/bin/sh

sudo apt update && sudo apt upgrade -y

# I/F
sudo apt install -y tig
sudo apt install -y wget
sudo apt install -y fd-find

# For Vim
sudo apt install -y fzf
sudo apt install -y ripgrep

sudo apt autoremove -y

