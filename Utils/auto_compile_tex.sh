#!/bin/sh

# -------------------------------------------------------------------------------------------
# texファイルの更新を検知したら自動でコンパイルするためのスクリプト.(shell環境用)
# - CPUが強いマシンでこのコードを動かしておくと楽.
# - クラウドストレージ上で作業すると,どこから編集してもコンパイルしてくれるので,
#   擬似overleafみたいで楽しい.
# - texlive とかのコンパイル用の環境(platexコマンドなど)は必要なので要注意.
#
# 実行例:
# $ ./auto_compile_tex.sh texlife.tex
# -------------------------------------------------------------------------------------------


# コンパイル対象のマスターファイルを指定
if [ -z $1 ]; then
  echo "引数が必要. (実行例 : ./auto_compile.sh Thesis.tex)"
  exit 1
else
  TEX_FILE=$1
fi

# カレントディレクトリ以下のtexファイルの最新更新日時を取得
LatestUpdate() {
  # 解説
  # find ./ -name "*.tex"                       : 全ての.tex ファイルを検索し，標準出力に出力
  # | xargs -0 -I {} stat --format=%Z {}        : ファイルの最新更新日時を列挙
  # | awk '{if(max<$1) max=$1} END {print max}' : 上の出力に対して最大値(最新更新日時)を出力
  TOTAL_UPDATE=`find ./ -name "*.tex" -print0 | xargs -0 -I {} stat --format=%Z {} | awk '{if(max<$1) max=$1} END {print max}'`
  echo $TOTAL_UPDATE
}

# コンパイル処理の定義
compile() {
  FILE=${TEX_FILE%.*}
  DVI_FILE=${FILE}.dvi
  DEL_TARGET="\.(aux|bbl|blg|brf|dvi|log|lof|lot|synctex.gz|toc)"

  platex -interaction=nonstopmode ${FILE}.tex  # aux作成
  pbibtex ${FILE}                              # bbl作成
  platex -interaction=nonstopmode ${FILE}.tex  # bbl取り込み/aux更新
  platex -interaction=nonstopmode ${FILE}.tex  # auxを反映させたdvi作成
  dvipdfmx ${DVI_FILE}                         # dviからpdf化
  find ./ | egrep ${DEL_TARGET} | xargs rm -rf # 余計なファイルを削除
}

# このスクリプトの実行間隔を指定[sec]
WATCH_INTERVAL=1
# 現状最新の更新日時を取得
BEFORE_UPDATE=`LatestUpdate $1`

# .tex監視開始
while true;
do
  # 現在のファイル更新日時を取得
  CURRENT_UPDATE=`LatestUpdate $1`
  # 最後に取得した更新日時が最新更新日時と違ったらコンパイル実行
  if [ "${BEFORE_UPDATE}" != "${CURRENT_UPDATE}" ];
  then
    # LaTeX のコンパイル実行
    compile
    # 最終更新日時を更新
    BEFORE_UPDATE=${CURRENT_UPDATE}
  fi
  # 待機
  sleep ${WATCH_INTERVAL}
done

