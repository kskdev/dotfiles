#!/usr/bin/env bash

# Vim ソースビルド・インストールスクリプト (Linux/apt環境)
#
# 用途:
#   - 通常のLinux環境
#   - Dockerコンテナ (root権限)
#   - sudo権限のあるユーザ環境
#
# 利用想定:
#   - Ubuntu : ターゲット
#   - macOS  : 非ターゲット．(brew から入れる)
#   - Windows: 非ターゲット
#
# ref: https://vim-jp.org/docs/build_linux.html
#
# How to uninstall:
#   cd <cloned vim dir>
#   make uninstall
#
# 環境変数:
#   VIM_PREFIX : インストール先 (デフォルト: /opt/vim91)
#

set -e

# root判定: root なら sudo 不要
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
  echo "[INFO] Running as root (no sudo needed)"
else
  SUDO="sudo"
  echo "[INFO] Running as user (using sudo)"
fi

# 設定
VIM_VERSION="v9.1.2050"
VIM_PREFIX="${VIM_PREFIX:-/opt/vim91}"
BUILD_VIM_DIR="${HOME}/BuiltVim"

# 作業ディレクトリ準備
if [ -d "$BUILD_VIM_DIR" ]; then
  echo "[REMOVED] $BUILD_VIM_DIR"
  rm -rf "$BUILD_VIM_DIR"
fi
echo "[MKDIR] $BUILD_VIM_DIR"
mkdir -p "$BUILD_VIM_DIR"
cd "$BUILD_VIM_DIR"

# 依存パッケージのインストール
echo "[INSTALL] Required packages..."

BASE_PACKAGES=(
  git
  build-essential
  gettext
  libtinfo-dev
  libncurses-dev
  libacl1-dev
  libgpm-dev
  libperl-dev
  python3-dev
  ruby-dev
  autoconf
  automake
  cproto
)

$SUDO apt-get update
$SUDO apt-get -y install "${BASE_PACKAGES[@]}"

# ソース取得
echo "[CLONE] Vim source..."
git clone https://github.com/vim/vim.git
mv vim vim91
cd vim91
git checkout "$VIM_VERSION"

# ビルド
echo "[BUILD] Configuring..."
make distclean 2>/dev/null || true

# CUI Only
./configure \
  --prefix="$VIM_PREFIX" \
  --with-features=huge \
  --enable-gui=no \
  --with-tlib=ncursesw \
  --enable-clipboard \
  --enable-python3interp \
  --with-python3-command=/usr/bin/python3 \
  --enable-fail-if-missing

echo "[BUILD] Compiling..."
make -j"$(nproc)"

# インストール
echo "[INSTALL] Installing to $VIM_PREFIX..."
$SUDO make install

# PATH設定 (シェル設定ファイルに追加)
echo ""
echo "=== Post-install ==="

if [ -f "$HOME/.zshrc" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
  SHELL_RC="$HOME/.bashrc"
else
  SHELL_RC=""
fi

STR_VIM_PATH="export PATH=\"$VIM_PREFIX/bin:\$PATH\""
STR_ALIAS_VIM="alias vim=\"$VIM_PREFIX/bin/vim\""

if [ -n "$SHELL_RC" ]; then
  if grep -q "$VIM_PREFIX/bin" "$SHELL_RC" 2>/dev/null; then
    echo "[SKIPPED] PATH already configured in $SHELL_RC"
  else
    echo "" >> "$SHELL_RC"
    echo "# Built Vim ($VIM_VERSION)" >> "$SHELL_RC"
    echo "$STR_VIM_PATH" >> "$SHELL_RC"
    echo "$STR_ALIAS_VIM" >> "$SHELL_RC"
    echo "" >> "$SHELL_RC"
    echo "[ADDED] PATH to $SHELL_RC"
  fi
else
  echo "[INFO] No .zshrc or .bashrc found"
  echo "[INFO] Add the following to your shell config:"
  echo "  $STR_VIM_PATH"
  echo "  $STR_ALIAS_VIM"
fi

echo ""
echo "[DONE] Vim $VIM_VERSION installed to $VIM_PREFIX"
echo "[INFO] Run 'source $SHELL_RC' or restart shell to use"
