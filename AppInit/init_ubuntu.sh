#!/bin/sh


sudo apt update && sudo apt upgrade -y


# ::::: Base
sudo apt install -y unzip
sudo apt install -y build-essential
sudo apt install -y software-properties-common
sudo apt install -y git
sudo apt install -y curl


# ::::: I/F Apps
sudo apt install -y zsh
sudo apt install -y tmux
sudo apt install -y fzf
sudo apt install -y ripgrep


# ::::: Dev apps
sudo apt install -y portaudio19-dev  # pyaudio depends on this library.


# Deno (For vim plugins made in denops.)
curl -fsSL https://deno.land/install.sh | sh
DENO_EXPORT1="$(HOME)/.deno/bin/deno"
DENO_EXPORT2="\$DENO_INSTALL/bin:\$PATH"
if grep ${DENO_EXPORT1} ~/.zshrc >/dev/null; then
  echo "[SKIPPED] Already exists deno path in ~/.zshrc"
  :
else
  echo ${DENO_EXPORT1} >> ~/.zshrc
  echo ${DENO_EXPORT2} >> ~/.zshrc
  echo "[ADD] Write Deno path in ~/.zshrc"
fi


# ::::: Others


sudo apt autoremove -y

# ------------------------- Settings

# Set Directory name Englishization
LANG=C xdg-user-dirs-gtk-update

# # ::::: Change login shell (bash -> zsh) required password
# chsh -s $(which zsh)
# # ::::: 終了処理
# exec $SHELL -l

