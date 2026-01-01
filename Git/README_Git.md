# Git Configuration

Git の共通設定を管理

- このディレクトリは個人情報や認証情報は管理の対象外とする

## 構成

- `.gitconfig`: 共通の動作設定やエイリアスを定義 (公開用)
- `.gitignore_global`: OS やエディタが生成するファイル群の gitignore
- `.gitignore_python`: Python 開発用の gitignore
- `make_link.sh`: 上記の設定ファイルのシンボリックリンク作成スクリプト

## セットアップ手順

### 1. シンボリックリンクの作成

以下のコマンドを実行して共通設定をホームディレクトリに紐づける

```bash
sh make_link.sh
```

### 2. 個人情報の設定 (`~/.gitconfig.local`)

`make_link.sh` を実行すると，`~/.gitconfig.local` の雛形を生成する

このファイルに自分の名前とメールアドレスを追記する

```ini
[user]
    name  = Taro Yamada
    email = yamada@example.com
```

### 3. 認証情報の管理 (`~/.git-credentials`)

Personal Access Token (PAT) による認証管理合は，以下の手順を実行する

ホームディレクトリ直下に `.git-credentials` を作成する

```text
https://<username>:<token>@github.com
```

※ `Git/.git-credentials` に配置しても，セキュリティのため `.gitignore` で管理対象外に設定

## その他

Proxy や Credential の個別設定は `make_link.sh` で生成する

- `make_link.sh` は， `~/.gitconfig.local` を生成する
- `.gitconfig` 自体は，リポジトリ管理対象
  - 個人情報を書かないように注意！
