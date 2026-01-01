#!/bin/sh
#
# macOS/Linux用 vimrc インストールスクリプト
#
# 前提条件:
#   - macOS: brew install fzf ripgrep deno
#   - Linux: apt install fzf ripgrep deno (または各パッケージマネージャで)
#

set -e

SOURCE_VIMRC="./vimrc_alone"
TARGET_VIMRC="${HOME}/.vimrc"

# vimrc をホームディレクトリにコピー
cp ${SOURCE_VIMRC} ${TARGET_VIMRC}
echo "[DONE] Copied vimrc_alone to ${TARGET_VIMRC}"

# プラグインの自動インストール (初回起動時)
echo "[INFO] プラグインのインストールはvim起動時に自動で行われます"
echo "[INFO] vim を起動してください"
