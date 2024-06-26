#!/bin/sh

# ::::::::::::::::::::::::::::::::::::::::
# 最小限のアプリのインストール
# ::::::::::::::::::::::::::::::::::::::::

# ::::: パッケージアップグレード
sudo apt update && sudo apt upgrade -y

# ::::: 基本パッケージ
sudo apt install unzip -y
sudo apt install build-essential -y

# ::::: zsh インストール
sudo apt install zsh -y

# ::::: Vim (一旦削除してから再インストール. vim-tiny -> vim-huge)
sudo apt remove vim -y
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt update
sudo apt install vim -y

# ::::: neovim
# sudo apt install software-properties-common -y
# sudo add-apt-repository ppa:neovim-ppa/stable -y
# sudo apt-get update
# sudo apt install neovim -y

# ::::: Tmux
sudo apt install tmux -y

# # ::::: NodeJS
# # ref: https://qiita.com/seibe/items/36cef7df85fe2cefa3ea
# sudo apt install nodejs npm -y
# # ::::: n package(NodeJS のパッケージマネージャ)
# sudo npm install n -g
# sudo n stable
# sudo apt purge -y nodejs npm

# ::::: Deno (For Creating vim env)
curl -fsSL https://deno.land/x/install/install.sh | sh
# rcファイルに追記
DENO_EXPORT1="$(HOME)/.deno"
DENO_EXPORT2="\$DENO_INSTALL/bin:\$PATH"
if grep ${DENO_EXPORT1} ~/.zshrc; then
    echo "pattern exists."
    :
else
    echo "pattern does not exists. add setting to ~/.zshrc"
    echo ${DENO_EXPORT1} >> ~/.zshrc
    echo ${DENO_EXPORT2} >> ~/.zshrc
fi

# ::::: Git
sudo apt install -y git

# ::::: その他特定ライブラリ
sudo apt install portaudio19-dev -y  # pyaudio depends on this library.

# ::::: Python with pyenv
# ref: https://qiita.com/micheleno13/items/39ad85cfe44ca32f53ee
# git clone https://github.com/pyenv/pyenv.git ~/.pyenv
# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
# echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
# echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
# source ~/.bash_profile

# # pyenvインストール時の依存ライブラリ
# sudo apt install zlib1g-dev
# sudo apt install libssl-dev

sudo apt autoremove -y

# ------------------------- Settings

# # ::::: ログインシェルの変更 (bash -> zsh) required password
# chsh -s $(which zsh)
# # ::::: 終了処理
# exec $SHELL -l
