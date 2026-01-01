# Tmux Configuration

端末内でのマルチウィンドウ，ペイン分割を管理する設定ファイル群．

## 構成

- **tmux.conf**: tmux のメイン設定ファイル．
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

## プラグイン管理 (TPM)

プラグインマネージャとして [tpm](https://github.com/tmux-plugins/tpm) を使用．

- プラグインのインストール: `prefix + I`（初回必須）
- プラグインのアップデート: `prefix + U`
- 設定のセーブ（resurrect）: `prefix + Ctrl + s`
- 設定のロード（resurrect）: `prefix + Ctrl + r`

## 補足

- **Mac 利用者への注意**: クリップボード連携のため `brew install reattach-to-user-namespace` のインストールを推奨．
- **Linux 利用者への注意**: クリップボード連携のため `xsel` のインストールを推奨．
