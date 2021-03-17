#!/bin/sh

# ::::::::::::::::::::::::::::::::::::::::
# .zshrc 導入用スクリプト.
# ::::::::::::::::::::::::::::::::::::::::


# -----------------------------------
# ~/.zshrc が存在しなければ作成する
# -----------------------------------
IS_ZSHRC=${HOME}/.zhsrc
if [ -e ${IS_ZSHRC} ]; then
  # Pass
  :
else
    echo "${IS_ZSHRC} is doesn't found. Create .zshrc"
    touch ${IS_ZSHRC}
fi

# -----------------------------------
# 自分用 zshrc の読み込み処理を ~/.zshrc に追記
# -----------------------------------
MYZSHRC_ABS_PATH=$(cd $(dirname $0); pwd)"/myzshrc.sh"
REQUIRED_TXT="source ${MYZSHRC_ABS_PATH}"
# if grep ${REQUIRED_TXT} ~/.zshrc >/dev/null; then
if grep ${REQUIRED_TXT} ~/.zshrc; then
    echo "pattern exists."
    :
else
    echo "pattern does not exists. add setting to ~/.zshrc"
    echo ${REQUIRED_TXT} >> ~/.zshrc
fi

