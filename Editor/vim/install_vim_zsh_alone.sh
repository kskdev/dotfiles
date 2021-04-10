#!/bin/sh

case ${OSTYPE} in
  darwin*)
    echo "Install vim plugins for MacOS. Let's Launch vim."

    SOURCE_VIMRC="./vimrc_alone"
    TARGET_VIMRC="${HOME}/.vimrc"
    TARGET_DEIN="${HOME}/.vim/dein/"

    cp ${SOURCE_VIMRC} ${TARGET_VIMRC}

    SOURCE_FZF="./bins/fzf_bin/fzf-0.23.0-linux_amd64/fzf"
    SOURCE_RIP="./bins/rg/ripgrep-12.1.1-x86_64-unknown-linux-musl/rg"
    TARGET_FZF="${TARGET_DEIN}/repos/github.com/junegunn/fzf/bin/"

    mkdir -p ${TARGET_FZF}
    cp ${SOURCE_FZF} ${TARGET_FZF}
    cp ${SOURCE_RIP} ${TARGET_FZF}
    ;;

  linux*)
    echo "Install vim plugins for Linux. Let's Launch vim."

    SOURCE_VIMRC="./vimrc_alone"
    TARGET_VIMRC="${HOME}/.vimrc"
    TARGET_DEIN="${HOME}/.vim/dein/"

    cp ${SOURCE_VIMRC} ${TARGET_VIMRC}

    vim -e -c ":silent! call dein#install() | :q"

    SOURCE_FZF="./bins/fzf_bin/fzf-0.23.0-linux_amd64/fzf"
    SOURCE_RIP="./bins/rg/ripgrep-12.1.1-x86_64-unknown-linux-musl/rg"
    TARGET_FZF="${TARGET_DEIN}repos/github.com/junegunn/fzf/bin/"

    mkdir -p ${TARGET_FZF}
    cp ${SOURCE_FZF} ${TARGET_FZF}
    cp ${SOURCE_RIP} ${TARGET_FZF}
    ;;

esac
