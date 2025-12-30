#!/usr/bin/env zsh

set -euo pipefail

# --- このスクリプトがあるディレクトリを基準にする ---
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
cp -f -- "${DOTFILES_DIR}/settings.json" \
         "${ANTIGRAVITY_SETTINGS_DIR}/settings.json"

cp -f -- "${DOTFILES_DIR}/keying ${ext}..."
  antigravity --force --install-extension "${ext}"
done < "${EXTENSIONS_FILE}"

echo
echo "============================"
echo " Done! ANTIGRAVITY setup is complete."
echo

# --- バッチの PAUSE 相当 ---
read -r "?Press Enter to exit..."

