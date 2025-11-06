#!/bin/sh

sudo apt update && sudo apt upgrade -y

# Audio
sudo apt install -y sox
sudo apt install -y portaudio19-dev  # pyaudio depends on this library.

sudo apt autoremove -y

# Deno (for my vim envrionment. (using denops))
curl -fsSL https://deno.land/install.sh | sh
INSTALL_PATH_DENO="$HOME/.deno/bin"
if grep ${INSTALL_PATH_DENO} ~/.zshrc >/dev/null; then
  echo "[SKIPPED] Already exists deno path in ~/.zshrc"
else
  echo "# Deno" >> ~/.zshrc
  echo "export PATH=\"$INSTALL_PATH_DENO:\$PATH\"" >> ~/.zshrc
  echo "" >> ~/.zshrc
  echo "[ADD] Write Deno path in ~/.zshrc"
fi

