#!/bin/sh

# インストール中に質問されないように設定
export DEBIAN_FRONTEND=noninteractive

# sudo コマンドが利用可能かチェックし、root の場合は sudo を空にする
# 目的は，sudo コマンド不要の環境(既にroot環境)でも，sudo コマンドを実行できるようにする
if [ "$(id -u)" -eq 0 ]; then
    alias sudo=''
elif ! command -v sudo > /dev/null; then
    echo "This script requires sudo. Please install sudo or run as root."
    exit 1
else
    # 一般ユーザの場合は sudo のタイムアウトを更新
    sudo -v
fi

# パッケージリストの更新
sudo apt update

# 各セットアップスクリプトの実行
sh ./essential.sh
sh ./development.sh
sh ./utility_apps.sh

# 不要になったパッケージの削除
sudo apt autoremove -y
