#!/bin/sh

# ::::::::::::::::::::::::::::::::::::::::
# 環境構築 on Ubuntu
# ::::::::::::::::::::::::::::::::::::::::

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- install apps
printf '\033[31m%s\033[m\n' " ::: 1. Install apps via apt "
(cd "${SCRIPT_DIR}/Ubuntu" && sh init_ubuntu.sh)

# --- setup tmux configs
printf '\033[31m%s\033[m\n' " ::: 2. Setup tmux configs "
(cd "${SCRIPT_DIR}/Tmux" && sh make_link.sh)

# --- setup zsh configs
printf '\033[31m%s\033[m\n' " ::: 3. Setup zsh configs "
(cd "${SCRIPT_DIR}/Shell" && sh zshrc_init.sh)

# --- setup vim configs
printf '\033[31m%s\033[m\n' " ::: 4. Setup vim configs "
(cd "${SCRIPT_DIR}/Vim" && sh install.sh)

# --- setup others settings.
printf '\033[31m%s\033[m\n' " ::: Ex. Setup others configs "
ZSH_PATH="$(command -v zsh || true)"
if [ -n "${ZSH_PATH}" ] && [ "${SHELL}" != "${ZSH_PATH}" ]; then
    echo "input password for changing login shell."
    chsh -s "${ZSH_PATH}" || echo "Warning: Could not change shell with chsh. Run 'exec zsh -l' or edit ~/.bashrc."
fi
echo "Please re-login or run 'exec zsh -l' to apply ~/.zshrc."

echo " "
echo " "
printf '\033[31m%s\033[m\n' " Done setup. hello myworld. "
echo ""
echo " "
echo " "
