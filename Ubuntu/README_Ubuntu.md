# Ubuntu Setup Scripts

Ubuntu 環境（VM，Docker，GPU レンタルサーバ等）の初期セットアップを行うスクリプト群．
root ユーザおよび sudo 権限保持ユーザの両方に対応している．

## 構成

- **init_ubuntu.sh**: メインの実行スクリプト．各サブスクリプトを一括で呼び出す．
- **essential.sh**: 基本ツール（git, curl, zsh, tmux, htop 等）のインストールとシェル設定．
- **development.sh**: 開発用ライブラリ（sox, portaudio19-dev）および Deno のインストール．
- **utility_apps.sh**: 効率化ツール（tig, fzf, ripgrep, fd-find 等）のインストール．

## 特徴

- **安全性**: GPU ドライバ等の破損を防ぐため，`apt upgrade` は行わず `apt update` のみに留めている．
- **ノンインタラクティブ**: `DEBIAN_FRONTEND=noninteractive` を指定し，インストール中の対話型プロンプト（地域設定等）を抑制．
- **権限自動判別**: root ユーザ環境では `sudo` を無視し，一般ユーザ環境では `sudo` を使用するように自動調整．
- **Headless 対応**: GUI 環境がないサーバ環境でもエラーが出ないように設定済み．

## 使い方

### 一括実行

```bash
sh init_ubuntu.sh
```

### 個別実行

個別に依存パッケージをインストールしたい場合は，各サブスクリプトを直接実行可能．

```bash
sh essential.sh
```

## 注意事項

- セットアップ完了後，ログインシェルを `zsh` に反映させるには再ログインが必要．
- `chsh` が不許可の環境では，`.bashrc` の末尾に `exec zsh -l` を追記して対応すること．
- Deno 等の環境変数は，実行時に自動で `~/.zshrc` へ追記される．
