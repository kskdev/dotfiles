#!/bin/sh

sudo apt update && sudo apt upgrade -y

sh ./essential.sh
sh ./development.sh
sh ./utility_apps.sh

sudo apt autoremove -y

