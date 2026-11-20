---
name: refactor-python-ml
description: Refactor or design-review Python machine-learning code when refactoring quality is the main request. Use when the user asks to refactor, restructure, split responsibilities, separate primitives, clarify configuration boundaries, improve maintainability/reuse/replaceability, or when a medium-or-larger Python/PyTorch ML change needs repo-fit structure guidance. Do not use for ordinary bug fixes, small feature additions, training runs, simple code explanations, or routine implementation unless refactoring/design quality is central.
---

# Refactor Python ML

Pythonおよび機械学習コードを、再利用可能な小さい部品と、それらを組み合わせる上位処理へ整理する
既存の挙動とユーザーが指定した変更範囲を維持し、スタイル適用だけを理由に不要な全面改修を行わない

通常のバグ修正、小さな機能追加、学習実行、単純なコード説明では原則使用しない
中規模以上の修正や追加で、責務分離、設定境界、差し替え可能性、保守性の判断が必要な場合に使用する

## 1. 対象を調査する

- リポジトリ固有の`AGENTS.md`、設定、テスト、formatter規則を先に読む
- 対象クラスの呼び出し側、入力、出力、学習可能パラメータ、checkpoint互換性を確認する
- ユーザーの未コミット変更を保持し、対象外のコードを変更しない
- 実装前に、現在の責務と将来差し替える可能性がある要素を整理する

## 2. 責務を分解する

- クラス、関数、モジュールへ1つの明確な責務だけを持たせる
- 自前モジュールへ依存しない再利用可能な基本部品を、機能ディレクトリの`Primitive/`へ配置する
- Primitiveを特定のTrainer、実験設定、データセット、複合損失へ依存させない
- 複合モジュールには、Primitiveの生成責務ではなく統合責務を持たせる
- 将来差し替える可能性があるモデル、損失、変換、評価器をコンストラクタなどから注入する
- 分離に再利用性、差し替え可能性、責務明確化の効果がない場合は、新しい抽象化を増やさない

詳細例が必要な場合は[style-examples.md](references/style-examples.md)を読む

## 3. 設定境界を明示する

- 必須設定を`config["key"]`で取得する
- 必須設定へ`dict.get(key, default)`や`setdefault()`を使用しない
- デフォルト値をコード内へ重複定義せず、YAMLなどの設定元へ明記する
- 型付き設定クラスにも暗黙のデフォルト値を持たせない
- 呼び出し側で保証済みの型を、下位クラスで繰り返し変換しない
- 同一内容を重複検証する`validate()`を追加しない

## 4. 読みやすい処理ブロックを実装する

- 長い処理を、名前から役割が分かるprivateメソッドへ分割する
- 関数内を小さい意味単位へ分け、各ブロックの直前へ目的を示す1行コメントを書く
- コメントでコードを逐語的に読み上げず、ブロック全体の意図を書く
- 異なる処理ブロック間へ空行を入れる
- 複雑な式を意味のある中間変数へ分解する
- 関連する引数名、型注釈、代入演算子を、可読性が上がる範囲で縦に揃える
- 対になる概念へ統一した命名を使う
    - 例: `similarity_pos` / `similarity_neg`
- 数式文脈が明確なら、`normalized`を`normed`、`positive` / `negative`を`pos` / `neg`と簡潔に表現してよい

## 5. docstringと型を整える

- クラス、`__init__`、公開メソッド、主要privateメソッドへ日本語docstringを書く
- docstringへ概要、`Args`、`Returns`を書く
- 利用者が必要とする場合だけ`Raises`を書く
- 日本語のdocstring、コメント、コード内の説明文では、文末の句点「。」を原則付けない
- 複数文を書く場合も改行や箇条書きで区切り、句点に依存しない簡潔な表現にする
- 引数と戻り値へ型注釈を付ける
- Tensorを受け渡すAPIでは、主要なshapeと各軸の意味を書く
- 長さ、次元数、Tensor shapeなどの内部不変条件は原則`assert`で確認する
- `assert`文はエラーメッセージを含めて1行80文字以内で記述する
- 外部入力エラーや復旧可能な実行時エラーには適切な例外を使用する
- 小さな処理へ不要なdataclass、TypedDict、ラッパーを追加しない

## 6. PyTorch境界を保つ

- 学習可能なTensorを`nn.Parameter`として登録する
- 複数の学習可能モジュールを`nn.ModuleList`または`nn.ModuleDict`へ登録する
- 基本アルゴリズム、複合損失、epochスケジュール、ログ処理を別責務へ分離する
- 学習専用ヘッドを推論モデルへ混在させない
- `.detach()`、device転送、dtype変換を必要な境界でのみ行う
- モデル、損失、Dataset、評価器、Trainerを密結合させない

## 7. 段階的に編集する

1. Primitiveまたは独立部品を作る
2. 既存の上位処理へ注入する
3. 呼び出し側を最小限変更する
4. 古い実装への参照を検索する
5. 参照がなく、互換性も不要なコードだけを削除する
6. 各段階で構文検査と対象テストを実行する

## 8. 検証する

- Primitiveを単体テストする
- 複合モジュールへPrimitiveまたはスタブを注入して統合規則をテストする
- 必須設定の欠落が暗黙補完されず失敗することを確認する
- Tensor shape、dtype、device、勾配伝播を確認する
- `nn.Parameter`、`nn.ModuleList`などの登録状態を確認する
- PyTorch Lightningを変更した場合は、可能なら最小学習・検証ループを実行する
- `py_compile`、対象テスト、全テスト、差分チェックを変更規模に応じて実行する

## 9. レビュー時の出力

- スタイル違反だけでなく、責務混在、暗黙設定、差し替え不能、Tensor shape不整合、未登録パラメータを優先して報告する
- 指摘を重要度順に並べ、対象ファイルと行を示す
- 修正案では、どのPrimitiveと上位統合処理へ分けるかを具体的に示す
- 問題がなければ、残るテスト不足や互換性リスクを明記する
