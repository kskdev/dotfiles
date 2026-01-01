#!/bin/sh
#
# macOS/Linux用 Vim設定 インストールスクリプト
#
# 前提条件:
#   - macOS: brew install fzf ripgrep deno
#   - Linux: apt install fzf ripgrep deno (または各パッケージマネージャで)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VIM_DIR="${HOME}/.vim"

# vimrc をホームディレクトリにコピー
cp "${SCRIPT_DIR}/vimrc" "${HOME}/.vimrc"
echo "[DONE] Copied vimrc to ~/.vimrc"

# dein/ ディレクトリをコピー
mkdir -p "${VIM_DIR}/dein"
cp -r "${SCRIPT_DIR}/dein/"* "${VIM_DIR}/dein/"
echo "[DONE] Copied dein/*.toml to ${VIM_DIR}/dein/"

# rc/ ディレクトリをコピー
mkdir -p "${VIM_DIR}/rc"
cp -r "${SCRIPT_DIR}/rc/"* "${VIM_DIR}/rc/"
echo "[DONE] Copied rc/*.vim to ${VIM_DIR}/rc/"

echo ""
echo "[INFO] プラグインのインストールはvim起動時に自動で行われます"
echo "[INFO] vim を起動してください"
