#!/usr/bin/env sh

# ref:
# https://vim-jp.org/docs/build_linux.html

# How to uninstall:
#   cd <cloned vim dir>
#   make uninstall


set -e


# working dir
BUILD_VIM_DIR=~/BuiltVim
if [ -d "$BUILD_VIM_DIR" ]; then
  echo "[REMOVED] $BUILD_VIM_DIR"
  rm -rf "$BUILD_VIM_DIR"
else
  echo "[MKDIR] ${STR_VIM_PATH}"
  mkdir "$BUILD_VIM_DIR"
fi
cd $BUILD_VIM_DIR


# install package
sudo apt -y install \
  git build-essential gettext libtinfo-dev libncurses-dev \
  libxmu-dev libxpm-dev libgtk-3-dev \
  libacl1-dev libgpm-dev  \
  libperl-dev python3-dev ruby-dev \
  autoconf automake cproto


# get source
git clone https://github.com/vim/vim.git
mv vim/ vim91/
cd vim91/
git checkout v9.1.1420


# build
make distclean

./configure \
--prefix=/opt/vim91 \
--enable-multibyte \
--enable-fontset \
--enable-xim \
--enable-terminal \
--enable-fail-if-missing \
--enable-cscope \
--with-features=huge \
--enable-gui=gtk3 \
--enable-python3interp \
--with-python3-command=/usr/bin/python3

make -j$(nproc)

# install
sudo make install


# add path and alias to ~/.zshrc
STR_VIM_PATH='export PATH="/opt/vim91/bin:$PATH"'
STR_ALIAS_VIM='alias vim="/opt/vim91/bin/vim"'

if grep ${STR_VIM_PATH} ~/.zshrc > /dev/null; then
  echo "[SKIPPED] Add built-vim path to zshrc"
  :
else
  echo "" >> ~/.zshrc
  echo \# Built Vim >> ~/.zshrc
  echo ${STR_VIM_PATH} >> ~/.zshrc
  echo ${STR_ALIAS_VIM} >> ~/.zshrc
  echo "" >> ~/.zshrc
  echo "[ADD PATH to zshrc] ${STR_VIM_PATH}"
fi

