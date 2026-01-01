#!/bin/bash

# Git設定ファイルのシンボリックリンクを作成するスクリプト

DOTFILES_GIT_DIR=$(cd $(dirname $0); pwd)

# 1. .gitconfig のリンク
if [ -L ~/.gitconfig ]; then
    rm ~/.gitconfig
fi
ln -s "${DOTFILES_GIT_DIR}/.gitconfig" ~/.gitconfig
echo "Created link: ~/.gitconfig"

# 2. .gitignore_global のリンク
if [ -L ~/.gitignore_global ]; then
    rm ~/.gitignore_global
fi
ln -s "${DOTFILES_GIT_DIR}/.gitignore_global" ~/.gitignore_global
echo "Created link: ~/.gitignore_global"

# 3. .gitconfig.local の雛形作成（存在しない場合のみ）
if [ ! -f ~/.gitconfig.local ]; then
    cat <<EOF > ~/.gitconfig.local
[user]
    name  = Your Name
    email = your.email@example.com

# [http]
#     proxy = http://proxy.example.com:8080
# [https]
#     proxy = http://proxy.example.com:8080

# [credential]
#     helper = store  # 保存先: ~/.git-credentials
EOF
    echo "Created template: ~/.gitconfig.local (Please edit this file!)"
fi
