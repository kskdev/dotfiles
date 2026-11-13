# Tmux Configuration

端末内でのマルチウィンドウ，ペイン分割を管理する設定ファイル群．

## 構成

- **tmux.conf**: tmux のメイン設定ファイル．
- **theme.conf**: ステータスバーやペインの配色設定．`tmux.conf` からリポジトリ内のファイルを直接読み込む．
- **make_link.sh**: ホームディレクトリへのシンボリックリンク作成スクリプト．
- **gpuinfo_tmux.sh**: ステータスバーに GPU 情報を表示するための補助スクリプト．

## 基本操作

プレフィックスキー（デフォルト）: `Ctrl + b`

### 起動・終了

- 起動: `tmux`
- 終了: `exit` または `Ctrl + d`
- セッション名の指定: `tmux new -s [session_name]`
- セッションからのデタッチ: `prefix + d`
- セッションへのアタッチ: `tmux a -t [session_name]`

### ウィンドウ操作

- 新規ウィンドウ作成: `prefix + c`
- ウィンドウ切り替え（右へ）: `prefix + Ctrl + l`
- ウィンドウ切り替え（左へ）: `prefix + Ctrl + h`
- ウィンドウ一覧選択: `prefix + w`

### ペイン操作

- 垂直分割: `prefix + |`
- 水平分割: `prefix + -`
- ペイン移動: `prefix + h, j, k, l`（Vim ライク）
- ペイン移動（順次）: `Ctrl + o`（プレフィックス不要）
- ペインのリサイズ: `prefix + H, J, K, L`（5 段階）

### その他

- 設定のリロード: `prefix + r`
- コピーモード開始: `prefix + [` （Vim ライクな操作可能）
- コピーモード中のヤンク: `y`（システムクリップボードと連携）

## テーマ

テーマ用のシンボリックリンクは不要．リポジトリを `~/dotfiles` 以外に配置した場合は，`tmux.conf` の `source-file ~/dotfiles/Tmux/theme.conf` を実際のパスに変更する．

`tmux.conf` の `@theme_name` で `modern`，`molokai`，`orange`，`iceberg`，`tender`，`ubuntu` を選択する．現在は `molokai` を選択している．不明な名前を指定した場合は `modern` になる．

配色は既定で HEX 色を使う．256 色指定を使う場合は `@theme_legacy` を `on` に変更する．色自体は `theme.conf` で編集できる．`ubuntu` の背景に使う `colour0` は端末のパレットに依存するため，HEX 色との差が出る場合がある．

ペイン上端には番号とプログラム名を表示する．アクティブなペインはテーマ色の境界線と，見出しの `●` および太字で示す．背景色は `color_pane` で指定する．

## プラグイン管理 (TPM)

プラグインマネージャとして [tpm](https://github.com/tmux-plugins/tpm) を使用．

- プラグインのインストール: `prefix + I`（初回必須）
- プラグインのアップデート: `prefix + U`
- 設定のセーブ（resurrect）: `prefix + Ctrl + s`
- 設定のロード（resurrect）: `prefix + Ctrl + r`

## 補足

- **Mac 利用者への注意**: クリップボード連携のため `brew install reattach-to-user-namespace` のインストールを推奨．
- **Linux 利用者への注意**: クリップボード連携のため `xsel` のインストールを推奨．
