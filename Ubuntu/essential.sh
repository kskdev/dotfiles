#!/bin/sh

# Install essential tools
sudo apt install -y git unzip build-essential software-properties-common curl
sudo apt install -y zsh tmux axel htop tree

# GUI環境がある場合のみディレクトリ名を英語化
if [ -n "$DISPLAY" ] && command -v xdg-user-dirs-gtk-update > /dev/null; then
    LANG=C xdg-user-dirs-gtk-update
fi

# ログインシェルを zsh に変更 (対話モードを避けるためのチェック)
# ※ chsh が使えない環境（一部のレンタルサーバー等）では、.bashrc の末尾に "exec zsh -l" を書くのが確実です。
CURRENT_USER=$(whoami)
ZSH_PATH=$(which zsh)

if [ "$SHELL" != "$ZSH_PATH" ] && [ -n "$ZSH_PATH" ]; then
    echo "Attempting to change login shell to zsh for $CURRENT_USER..."
    # パスワード入力を求められる可能性があるため、sudo を試みる
    sudo chsh -s "$ZSH_PATH" "$CURRENT_USER" || echo "Warning: Could not change shell with chsh. Please try manually or use .bashrc fallback."
fi

