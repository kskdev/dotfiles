#!/bin/sh

# -------------------------------------------------------------------------------------------
# 指定したファイル更新を検知して，それに伴ってコマンドを実行するスクリプト
# - 常にこのスクリプトは動作し続ける．
# - 対象ファイルについて，N秒前と現在時刻を比較することで，変化を検知
# - 現状は1ファイルしか対応していない.複数のファイルの定義はまたどこかでやるかもしれない
#
# 実行例:
# $ ./file_change_detector.sh foo.bar
#
# 因みに，類似した機能を持つ incron なるものがあるらしい...
# -------------------------------------------------------------------------------------------

# コンパイル処理の定義．
run() {
  # ここにファイル変化の検出をトリガーとしたときのコマンドを定義
  echo "\e[31m [DETECT] \e[m ${TARGET_FILE}"

}


# コンパイル対象のマスターファイルを指定
if [ -z $1 ]; then
  echo "引数が必要. (実行例 : ./file_change_detector.sh foo.txt)"
  exit 1
else
  TARGET_FILE=$1
fi

# このスクリプトの実行間隔を指定[sec]
WATCH_INTERVAL=1

# カレントディレクトリ以下のファイルの最新更新日時を取得
LatestUpdate() {
  # 編集箇所があるとすれば，"${TARGET_FILE}" 部分であり，
  # ここを, "*" とすれば，カレントディレクトリ以下のファイル・ディレクトリの更新を検知可能
  # 以下自分用解説
  # find ./ -name "$1"                          : 対象のファイルを検索し，標準出力に出力
  # | xargs -0 -I {} stat --format=%Z {}        : ファイルの最新更新日時を列挙
  # | awk '{if(max<$1) max=$1} END {print max}' : 上の出力に対して最大値(最新更新日時)を出力
  TOTAL_UPDATE=`find ./ -name "${TARGET_FILE}" -print0 | xargs -0 -I {} stat --format=%Z {} | awk '{if(max<$1) max=$1} END {print max}'`
  echo $TOTAL_UPDATE
}

# 現状最新の更新日時を取得
BEFORE_UPDATE=`LatestUpdate ${TARGET_FILE}`

# ファイル監視開始
while true;
do
  # 現在のファイル更新日時を取得
  CURRENT_UPDATE=`LatestUpdate ${TARGET_FILE}`
  # 最後に取得した更新日時が最新更新日時と違ったらコマンド実行
  if [ "${BEFORE_UPDATE}" != "${CURRENT_UPDATE}" ];
  then
    # コマンド実行
    run
    # 最終更新日時を更新
    BEFORE_UPDATE=${CURRENT_UPDATE}
  fi
  # 待機
  sleep ${WATCH_INTERVAL}
done

