#!/bin/sh

# Audio (optional, but keep as is)
sudo apt install -y sox portaudio19-dev

# Deno (for my vim envrionment. (using denops))
if ! command -v deno > /dev/null; then
    curl -fsSL https://deno.land/install.sh | sh
fi

INSTALL_PATH_DENO="$HOME/.deno/bin"
ZSHRC="$HOME/.zshrc"

if [ -f "$ZSHRC" ] && grep -Fq "$INSTALL_PATH_DENO" "$ZSHRC"; then
  echo "[SKIPPED] Already exists deno path in $ZSHRC"
else
  [ ! -f "$ZSHRC" ] && touch "$ZSHRC"
  echo "\n# Deno" >> "$ZSHRC"
  echo "export PATH=\"$INSTALL_PATH_DENO:\$PATH\"" >> "$ZSHRC"
  echo "[ADD] Write Deno path in $ZSHRC"
fi

