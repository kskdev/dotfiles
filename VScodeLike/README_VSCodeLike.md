# About

設定を端末間で同期するための `Sync` などが使えない環境向けに最低限の設定を管理

VSCode 系の設定はアプリごとに独立したディレクトリへ分割

- `VScode/` : Visual Studio Code 用
- `Antigravity/` : Antigravity 用

# How to use

## VSCode

- Windows: `VScode/install_extensions_vscode.bat`

## Antigravity

- Windows: `Antigravity/install_extensions_antigravity.bat`
- Linux/macOS (zsh): `Antigravity/install_extensions_antigravity.zsh`

各ディレクトリは独立しておりそれぞれ以下のファイルを保持

- `extensions.txt`
- `settings.json`
- `keybindings.json`
