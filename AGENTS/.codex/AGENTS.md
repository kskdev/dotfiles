# Language Rules
- Agent との対話 コメント Docstring ドキュメントは日本語を使用
- 既存実装が英語コメント主体の場合は既存方針を優先

# Comment Rules
- 日本語表現は句読点の代わりに半角スペースを用いて体言止めで簡潔に表現
- コメントは既存のコメント方針に従い 複雑な処理や意図が伝わりにくい変更にはコメント追加
  - 処理のまとまり単位で 1〜2 行で記述
  - 目的や内容を簡潔に記述
  - 未参照であればその旨を記述
- Docstring は新規追加または変更するクラスやメソッドに記述
  - 概要
  - 実装意図
  - Args
  - Return
- Args Return には型と説明を記載
- 関連する SKILL がある場合はそちらのルールを優先的に適用

# Git Rules
- 多数の変更に及ぶ場合は機能単位に分けて commit する
- Commit メッセージは英語で簡潔に記述
- Agent が commit する場合は種別を `[]` で囲む (`[]` で囲んだものを Agent の操作として扱う)
  - 例
    - `[feat] add user registration`
    - `[fix] handle null pointer`
    - `[refactor] clean up tmux settings`

# Change Policy
- 要求範囲外の変更は禁止
- リファクタリングは要求された場合のみ実施
- 命名変更のみの修正は禁止
- 既存コードスタイルを優先
- 修正は最小差分を基本とする

# Documentation Policy
- README は以下の項目を満たすように記述し 実装と不整合がある場合に更新
  - 概要
  - 環境構築
  - 利用方法

# Analysis Policy
- 修正前に関連実装を調査
- 推測で修正しない
- 不明点は現状実装を根拠に判断
- 影響範囲を確認してから変更
