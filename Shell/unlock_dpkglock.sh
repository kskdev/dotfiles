#!/bin/sh

# -----------------------------------
#  ロック /var/lib/dpkg/lock-frontend が取得できませんでした
# -----------------------------------
sudo rm /var/lib/apt/lists/lock
sudo rm /var/lib/dpkg/lock
sudo rm /var/lib/dpkg/lock-frontend

