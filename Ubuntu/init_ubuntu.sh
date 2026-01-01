#!/bin/sh

# インストール中に質問されないように設定
export DEBIAN_FRONTEND=noninteractive

# sudo コマンドが利用可能かチェックし、root の場合は sudo を関数として空定義する
if [ "$(id -u)" -eq 0 ]; then
    # rootの場合はsudoを何もしない関数として定義
    sudo() { "$@"; }
elif ! command -v sudo > /dev/null; then
    echo "This script requires sudo. Please install sudo or run as root."
    exit 1
else
    # 一般ユーザの場合は sudo のタイムアウトを更新
    sudo -v
fi

# パッケージリストの更新
sudo apt update

# 各セットアップスクリプトの実行（ドットコマンドで現在の環境を引き継ぐ）
. ./essential.sh
. ./development.sh
. ./utility_apps.sh

# 不要になったパッケージの削除
sudo apt autoremove -y
