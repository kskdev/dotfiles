# Vim Configuration

macOS および Linux 向けの Vim 設定ファイル．

## ファイル構成

| ファイル         | 説明                                                                           |
| ---------------- | ------------------------------------------------------------------------------ |
| `vimrc_alone`    | Vim 設定ファイル本体．`~/.vimrc` として利用                                    |
| `install_zsh.sh` | vimrc_alone をホームディレクトリにコピーするインストールスクリプト             |
| `build_vim.sh`   | ソースから Vim 9.1 をビルドしてインストールするスクリプト (Linux/apt 環境向け) |

## 前提条件

### 必須ツール

以下のツールがシステムにインストールされている必要がある:

- **fzf** - ファジー検索
- **ripgrep (rg)** - 高速 grep
- **deno** - ddc.vim (補完プラグイン) の依存

### macOS

```bash
brew install fzf ripgrep deno
```

### Linux (apt)

```bash
sudo apt install fzf ripgrep

# deno は公式インストーラを使用
curl -fsSL https://deno.land/install.sh | sh
```

## インストール方法

```bash
cd dotfiles/Vim
./install_zsh.sh
```

vim を起動すると，dein.vim が自動でプラグインをインストールする．

## 主な機能

- **dein.vim**: プラグイン管理
- **vim-lsp + vim-lsp-settings**: LSP (Language Server Protocol) によるコーディング支援
- **ddc.vim + pum.vim**: 補完機能
- **fzf.vim**: ファジー検索インターフェース
- **fern.vim**: ファイラ
- **lightline.vim**: カスタマイズされたステータスライン

## 主要キーマップ

| キー       | 動作                              |
| ---------- | --------------------------------- |
| `<Space>f` | ファイル検索 (FZF)                |
| `<Space>a` | Ripgrep 検索                      |
| `<Space>d` | バッファ一覧                      |
| `<Space>q` | 履歴                              |
| `<C-n>`    | ファイラ (Fern) トグル            |
| `gh`       | LSP: ホバー情報表示               |
| `gd`       | LSP: 定義ジャンプ                 |
| `gr`       | LSP: リネーム                     |
| `jj`       | インサートモード → ノーマルモード |
