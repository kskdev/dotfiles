# Python / ML Style Examples

## 目次

- Primitiveと複合処理
- 設定値
- 処理ブロック
- PyTorch登録
- 避ける実装

## Primitiveと複合処理

基本アルゴリズムは上位方式から独立させる

```python
class ClassificationLoss(nn.Module):
    """ 埋め込みへ分類損失を適用 """

    def forward(
        self,
        embeddings: torch.Tensor,
        labels    : torch.Tensor,
        margin    : float,
    ) -> tuple[torch.Tensor, torch.Tensor]:
        ...


class CompositeLoss(nn.Module):
    """ 注入された分類損失を複数条件へ適用して統合する """

    def __init__(self, classifiers: Sequence[nn.Module]) -> None:
        super().__init__()

        # 学習可能な分類損失をPyTorchへ登録
        self.classifiers = nn.ModuleList(list(classifiers))
```

上位処理で具体実装を組み立てる

```python
classifiers = [
    SphereFace2(input_dim=prefix_dim, ...)
    for prefix_dim in prefix_dims
]
loss_module = DAMELoss(classifiers=classifiers, ...)
```

## 設定値

必須設定は直接取得する

```python
scale       = config["sphereface2_scale"]
margin_type = config["sphereface2_margin_type"]
```

暗黙のデフォルト値を設定しない

```python
# 禁止
scale = config.get("sphereface2_scale", 30.0)
config.setdefault("sphereface2_scale", 30.0)
```

## 処理ブロック

処理を意味単位へ分け、ブロックの目的をコメントする

```python
# 入力埋め込みと分類重みを正規化して cosine similarity を計算
normed_embeds = F.normalize(embeddings, dim=1)
normed_weight = F.normalize(self.weight, dim=1)
cosine        = F.linear(normed_embeds, normed_weight).clamp(-1.0, 1.0)

# margin方式に応じた pos/neg logit を生成
similarity_pos, similarity_neg = self._apply_margin(cosine, margin)
logits_pos = self.scale * similarity_pos + self.bias
logits_neg = self.scale * similarity_neg + self.bias
```

## PyTorch登録

学習可能な値を通常のlistやTensorとして保持しない

```python
self.weight = nn.Parameter(torch.empty(num_classes, input_dim))
self.heads  = nn.ModuleList(heads)
```

固定Tensorをcheckpointとdevice移動の対象にする場合はbufferへ登録する

```python
self.register_buffer("alignment", alignment)
```

## 避ける実装

- 複合損失クラスの内部へ具体的な分類損失アルゴリズムを実装する
- Trainer内へモデル生成、損失数式、評価計算、描画処理を集中させる
- 必須設定を複数ファイルで別々にデフォルト補完する
- shapeの意味を説明せず、reshapeやtransposeを連続させる
- 呼び出し側で型が確定している値を各階層で繰り返し変換する
- スタイル適用だけを理由に対象外ファイルを一括リファクタする
