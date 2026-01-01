#!/usr/bin/env zsh

set -euo pipefail

# --- このスクリプトがあるディレクトリを基準にする ---
# ${0:A} は Zsh 特有の書き方で、スクリプトのフルパスを取得します
DOTFILES_DIR="$(cd -- "$(dirname -- "${0:A}")" && pwd)"

# --- ANTIGRAVITY 設定ディレクトリ ---
# XDG Base Directory に準拠
ANTIGRAVITY_SETTINGS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/Antigravity/User"

echo
echo " Copying ANTIGRAVITY settings..."
echo "============================"

echo "Settings.json Target   : ${ANTIGRAVITY_SETTINGS_DIR}/settings.json"
echo "Keybindings.json Target: ${ANTIGRAVITY_SETTINGS_DIR}/keybindings.json"

# --- 設定ディレクトリ作成 ---
mkdir -p -- "${ANTIGRAVITY_SETTINGS_DIR}"

# --- 設定ファイルをコピー ---
if [[ -f "${DOTFILES_DIR}/settings.json" ]]; then
    cp -f -- "${DOTFILES_DIR}/settings.json" \
             "${ANTIGRAVITY_SETTINGS_DIR}/settings.json"
fi

if [[ -f "${DOTFILES_DIR}/keybindings.json" ]]; then
    cp -f -- "${DOTFILES_DIR}/keybindings.json" \
             "${ANTIGRAVITY_SETTINGS_DIR}/keybindings.json"
fi

echo "Settings and keybindings have been copied."

echo
echo " Installing ANTIGRAVITY extensions..."
echo "================================"

# --- extensions.txt を一行ずつ読み込んで、拡張機能をインストールする ---
EXTENSIONS_FILE="${DOTFILES_DIR}/extensions.txt"

if [[ -f "${EXTENSIONS_FILE}" ]]; then
    while IFS= read -r ext || [[ -n "$ext" ]]; do
        # 空行やコメント（#）で始まる行をスキップ
        [[ -z "${ext// /}" || "${ext}" =~ ^# ]] && continue
        
        echo "Installing ${ext}..."
        # agy: antigravityのコマンドラインツール
        agy --force --install-extension "${ext}" || echo "Warning: Failed to install ${ext}. Skipping..."
    done < "${EXTENSIONS_FILE}"
else
    echo "Warning: ${EXTENSIONS_FILE} not found. Skipping extension installation."
fi

echo
echo "============================"
echo " Done! ANTIGRAVITY setup is complete."
echo

# --- バッチの PAUSE 相当 ---
read -r "?Press Enter to exit..."
