# About

設定を端末間で同期するための `Sync` などが使えない環境向けに、最低限の設定を管理する。

VSCode 系の設定は、アプリごとに独立したディレクトリへ分割している。

- `VScode/` : Visual Studio Code 用
- `Antigravity/` : Antigravity 用

# How to use

## VSCode

- Windows: `VScode/install_extensions_vscode.bat`

## Antigravity

- Windows: `Antigravity/install_extensions_antigravity.bat`
- Linux/macOS (zsh): `Antigravity/install_extensions_antigravity.zsh`

各ディレクトリは独立しており、それぞれ以下のファイルを持つ。

- `extensions.txt`
- `settings.json`
- `keybindings.json`

# Log

2026/04/08

- `VScodeLike/VScode/` と `VScodeLike/Antigravity/` に分割
- アプリごとに設定ファイルとインストーラを独立化

2026/01/01

- Antigravity 用のインストーラを作成
- README.md 更新

2025/06/11

- Windows 環境用のインストールバッチを作成
