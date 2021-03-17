#!/bin/sh

# シンボリックリンクを自動で作成(以下のコマンド叩くだけ)
# bash ./make_link.sh

# E.G. Create symbolic link.
# ln -s [シンボリックリンクを作成したいファイルのパス] [シンボリックリンクを置くフォルダのパス]
# ln -s ~/foo/bar/dotfiles/Tmux/.tmux.conf ~/
# ln -s ~/foo/bar/dotfiles/Tmux/gpuinfo_tmux.sh ~/
# シンボリックリンク削除 : unlink [シンボリックリンクのパス]

# --- Create symbolic link --- #

# Delete already link.
_TARGET1='.tmux.conf'
_TARGET2='gpuinfo_tmux.sh'
unlink ~/${_TARGET1}
unlink ~/${_TARGET2}

# リンクが存在しなければ，リンクを作成
_SOURCE1=$(pwd)'/'${_TARGET1}
if [ ! -e '~/'${_TARGET1} ]; then
  echo 'Create link : ' ${_SOURCE1}
  ln -s ${_SOURCE1} ~/
fi
_SOURCE2=$(pwd)'/'${_TARGET2}
if [ ! -e '~/'${_TARGET2} ]; then
  echo 'Create link : ' ${_SOURCE2}
  ln -s ${_SOURCE2} ~/
fi

