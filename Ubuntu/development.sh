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
  echo "" >> "$ZSHRC"
  echo "# Deno" >> "$ZSHRC"
  echo "export PATH=\"$INSTALL_PATH_DENO:\$PATH\"" >> "$ZSHRC"
  echo "[ADD] Write Deno path in $ZSHRC"
fi


# Pyenv
if ! command -v pyenv > /dev/null; then
  echo "[INSTALL] Pyenv requirements..."
  sudo apt install -y libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl
  echo "[INSTALL] Pyenv..."
  curl https://pyenv.run | bash
fi

if [ -f "$ZSHRC" ] && grep -Fq "PYENV_ROOT" "$ZSHRC"; then
  echo "[SKIPPED] Already exists pyenv config in $ZSHRC"
else
  [ ! -f "$ZSHRC" ] && touch "$ZSHRC"
  echo "" >> "$ZSHRC"
  echo "# Pyenv" >> "$ZSHRC"
  echo "export PYENV_ROOT=\"\$HOME/.pyenv\"" >> "$ZSHRC"
  echo "[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" >> "$ZSHRC"
  echo "eval \"\$(pyenv init -)\"" >> "$ZSHRC"
  echo "[ADD] Write pyenv config in $ZSHRC"
fi

