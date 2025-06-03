import numpy as np
import networkx as nx
import matplotlib.pyplot as plt
import itertools
import math
import japanize_matplotlib # 日本語フォント設定 (必要に応じてインストール: pip install japanize-matplotlib)
# japanize_matplotlib はインポートするだけで有効になるため、 if __name__ == "__main__": ブロックの外でOK

class VisualizeSimilarity:
    """ 辞書形式のデータから要素間の類似度を計算． NetworkXでグラフ化 """

    def __init__(self, data_dict, k_value=None, iterations=50, seed=42):
        """
        ScalarSimilarityVisualizerを初期化します。

        Args:
            data_dict (dict)           : label:floatの辞書
            k_value (float, optional)  : spring_layoutのkパラメータ．Noneの場合、自動計算
            iterations (int, optional) : spring_layoutの計算回数
            seed (int | None, optional): レイアウト計算の再現用
        """
        assert isinstance(data_dict, dict), "入力:辞書型"
        assert len(data_dict) >= 2, "比較には少なくとも2つの辞書が必要"
        # 値が数値であることのチェックを追加 (より堅牢にするため)
        assert all(isinstance(v, (int, float, np.number)) for v in data_dict.values()), \
               "辞書の全ての値は数値（int, float, np.number）である必要があります。"

        self.data_dict = data_dict
        self._k_value  = k_value
        self._iter_num = iterations
        self.seed      = seed

        self.graph          = None
        self.node_labels    = None
        self.pos            = None
        self._similarities  = []

        self.build_graph()

        if self._k_value is None:
            self.k_value = self._auto_calculate_k()
            print(f"k値が指定されなかったため、自動計算しました: k={self.k_value:.4f}")
        else:
            self.k_value = self._k_value


    def _calculate_similarity(self, score1, score2, epsilon=1e-6):
        print("類似度計算の方法を定義 正規化前提")
        """2つのスコア間の類似度を計算します (差の逆数)。"""
        difference = abs(score1 - score2)
        return 1.0 / (difference + epsilon)

    def build_graph(self):
        """ データ辞書に基づいてNetworkXグラフを構築します """
        self.graph = nx.Graph()
        self.node_labels = {key: str(key) for key in self.data_dict.keys()}
        self._similarities = []

        for key in self.data_dict.keys():
            self.graph.add_node(key)

        for key1, key2 in itertools.combinations(self.data_dict.keys(), 2):  # n_C_2
            score1 = self.data_dict[key1]
            score2 = self.data_dict[key2]
            similarity = self._calculate_similarity(score1, score2)
            self._similarities.append(similarity)
            self.graph.add_edge(key1, key2, weight=similarity)

        print(f"Graph built: {self.graph.number_of_nodes()} nodes, {self.graph.number_of_edges()} edges.")


    def _auto_calculate_k(self):
        """ グラフの特性に基づいてspring_layoutのk値を自動計算します。 """
        assert self.graph is not None, "k値計算前にグラフが構築されている必要があります。"
        n = self.graph.number_of_nodes()
        if n == 0: return 0.5
        epsilon = 1e-6
        if not self._similarities:
            k = 1.0 / math.sqrt(n)
        else:
            max_similarity = max(self._similarities) if self._similarities else 1.0
            k = (1.0 / math.sqrt(max_similarity + epsilon)) * (1.0 / math.sqrt(n)) * 5.0
        k = max(0.01, min(k, 10.0))
        return k

    def calculate_layout(self, recalculate_k=False):
        """ 構築されたグラフに対してspring_layoutを用いてノードの配置を計算します。 """
        assert self.graph is not None, "レイアウト計算前にグラフが構築されている必要があります。"
        if recalculate_k: self.k_value = self._auto_calculate_k()
        print(f"Calculating layout using spring_layout (k={self.k_value:.4f}, iterations={self._iter_num}, seed={self.seed})")
        self.pos = nx.spring_layout( self.graph, weight='weight', k=self.k_value, iterations=self._iter_num, seed=self.seed)

    def visualize(
            self,
            figsize=(12, 10),
            node_size=1600,
            node_color="skyblue",
            edge_alpha=0.8, # 色が見やすいように少し上げる
            edge_cmap_name="coolwarm", # <-- エッジの色付け用カラーマップ名
            label_fontsize=10,
            title="Similarity Score Graph",
            show_edges=True,
            show_labels=True,
            show_edge_labels=True,
            edge_label_fontsize=12,
            edge_label_format="{:.2f}"
                ):
        """
        計算されたレイアウトに基づいてグラフをMatplotlibで描画します。
        エッジの色を類似度に応じて変化させます (高=赤, 低=青)。

        Args:
            # ... (他の引数) ...
            edge_cmap_name (str, optional): エッジの色付けに使用するMatplotlibカラーマップ名。
                                            デフォルトは'coolwarm'。
            show_edge_labels (bool, optional): Trueの場合、エッジに類似度を表示します。
            edge_label_fontsize (int, optional): エッジラベルのフォントサイズ。
            edge_label_format (str, optional): エッジラベルの数値フォーマット。
        """
        assert self.graph is not None, "描画前にグラフが構築されている必要があります。"

        if self.pos is None: print("Layout not calculated yet. Calculating now...")
        if self.pos is None: self.calculate_layout()

        plt.figure(figsize=figsize)
        # ノード描画
        nx.draw_networkx_nodes(self.graph, self.pos, node_size=node_size, node_color=node_color, alpha=0.8)

        # エッジ描画 & ラベル準備
        edge_colors_list = "gray" # デフォルト/フォールバック色
        edge_widths_list = 1.0    # デフォルト/フォールバック幅
        edge_labels_dict = {}     # エッジラベル用辞書

        if show_edges and self.graph.number_of_edges() > 0:
            # 1. エッジと重みを取得 (描画順序のために G.edges() ベースで)
            edges_in_order = list(self.graph.edges())
            edge_weights_in_order = [self.graph[u][v]['weight'] for u, v in edges_in_order]

            if edge_weights_in_order:
                # 2. 重みを正規化 (0-1の範囲へ)
                min_w = min(edge_weights_in_order)
                max_w = max(edge_weights_in_order)
                is_diverse = max_w > min_w
                normalized_weights = []
                if is_diverse:
                    denominator = max_w - min_w
                    normalized_weights = [(w - min_w) / denominator for w in edge_weights_in_order]
                else:
                    # 全ての重みが同じ場合、中間値(0.5)を使う
                    normalized_weights = [0.5] * len(edge_weights_in_order)

                # 3. カラーマップを取得し、正規化された重みに基づいて色を決定
                cmap = plt.get_cmap(edge_cmap_name)
                edge_colors_list = [cmap(norm_w) for norm_w in normalized_weights]

                # 4. エッジの太さも正規化された重みに応じて変化させる
                edge_widths_list = [1 + 8 * norm_w for norm_w in normalized_weights]

                # 5. エッジラベル用の辞書を作成 (show_edge_labelsがTrueの場合)
                if show_edge_labels:
                    # get_edge_attributes を使って (u, v) -> weight の辞書を取得
                    edge_weights_map = nx.get_edge_attributes(self.graph, 'weight')
                    edge_labels_dict = {edge: edge_label_format.format(weight) for edge, weight in edge_weights_map.items()}

            # 6. エッジを描画
            print(f"{edge_colors_list=}")
            nx.draw_networkx_edges(
                self.graph, self.pos,
                edgelist=edges_in_order, # 色/幅リストとの順序を一致させる
                width=edge_widths_list,
                edge_color=edge_colors_list, # 計算した色リストまたはフォールバック色
                alpha=edge_alpha
            )

            # 7. エッジラベルを描画 (show_edge_labelsがTrueの場合)
            # nx.draw_networkx_edges の後に呼ぶとラベルがエッジの上に描画されやすい
            if show_edge_labels and edge_labels_dict:
                nx.draw_networkx_edge_labels(
                    self.graph, self.pos,
                    edge_labels=edge_labels_dict,
                    font_size=edge_label_fontsize,
                    font_color='black',
                    bbox=dict(facecolor='white', alpha=0.6, edgecolor='none', boxstyle='round,pad=0.1') # 半透明の背景を追加
                )

        # ノードラベル描画
        if show_labels and self.node_labels:
            nx.draw_networkx_labels(
                self.graph, self.pos,
                labels=self.node_labels,
                font_size=label_fontsize
                # font_family は japanize_matplotlib がrcParamsを自動設定するため不要
            )

        # タイトルと表示設定
        if title:
            plt.title(title, fontsize=14)
        plt.axis("off")
        plt.tight_layout()
        plt.show()


if __name__ == "__main__":
    plt.rcParams['font.family'] = "Yu Gothic" # または 'MS Gothic', 'Hiragino Sans' など
    plt.rcParams['axes.unicode_minus'] = False

    people_scores = { "佐藤": 98.4, "鈴木": 95, "ボブ": 98, "アリス": 23, "伊藤": 25, "山田": 15, "川村": 60, "森田": 65 }
    visualizer = VisualizeSimilarity(people_scores, k_value=None, iterations=200, seed=42)
    visualizer.visualize(
        node_color="lightblue",
        title="Cosine Similarity relation graph",
        edge_cmap_name="tab10",   # 色付けに使用するカラーマップ
        edge_label_fontsize=10,       # エッジラベルのフォントサイズ
        edge_alpha=0.6               # エッジの透明度
    )