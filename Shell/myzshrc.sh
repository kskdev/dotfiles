#!/bin/sh

# ::::::::::::::::::::::::::::::::::::::::
# zsh setting for MacOS
# ::::::::::::::::::::::::::::::::::::::::

# ------------------------------
# Versions
# zsh 5.7.1 (x86_64-apple-darwin19.0)
# - All green.


# ------------------------------
# TODO and Tips
# ------------------------------
# このファイル一つであらゆる端末(ホストごと)の設定を管理したい.
# そのために必要なことは端末を認識し，それぞれの環境に合った設定を書く必要がある．
# 現在は MacOS(Catalina) 向けの設定になっている．

# shを変更するときに必要なコマンド
# chsh -s $(which zsh)


# ------------------------------
# ホスト別設定
# ------------------------------

case ${HOST} in
    "FOO")
        export TERM=xterm-256color
        ;;
    "BAR")
        export TERM=xterm-256color
        ;;
esac


# ------------------------------
# General settings
# ------------------------------
# historyの記録設定
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
# 日本語を使用
export LANG=ja_JP.UTF-8
# 日本語ファイル名を表示の有効化
setopt print_eight_bit
# ビープを鳴らさない
setopt nobeep
# Ctrl+d でzshを終了しない
setopt ignore_eof
# 色の変更(プロンプトのカスタマイズ用)
autoload -Uz colors; colors
# 補完機能を有効にする
autoload -Uz compinit; compinit
# 単語の入力途中でもTab補完を有効化
setopt complete_in_word
# 補完候補をハイライト&選択有効化
zstyle ':completion:*:default' menu select=1
# キャッシュの利用による補完の高速化
zstyle ':completion::complete:*' use-cache true
# パス補完時に大文字小文字を区別しないで補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補間候補の色付け
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# 補完候補を一覧表示
setopt auto_list
# 補完候補を詰めて表示
setopt list_packed
# コマンドミスを修正
setopt correct
# コマンドミス発生時の対話プロンプト
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? ([y]es/[n]o/[a]bort/[e]dit) => "
# バックグラウンドジョブが終了したらすぐに通知
setopt no_tify
# # 補完のリストの、選択している部分を塗りつぶす
# zstyle ':completion:*' menu select
# タブによるファイルの順番切り替え
setopt auto_menu
# cd -[tab]で過去の移動先をリスト&ジャンプ(pushd)
setopt auto_pushd
# pushd から重複削除
setopt auto_pushd
# パスだけを入力された場合，そのパスへ移動
setopt auto_cd
# '#'以降の文字列を無視
setopt interactive_comments
# 同時に起動したzsh間で履歴を共有
setopt share_history
# historyに同一のコマンド記録があれば更新(記録の重複をしない)
setopt hist_ignore_all_dups
# 重複を記録しない
setopt hist_ignore_dups
# 補完時にhistoryを自動展開
setopt hist_expand
# 余白を詰めて記録
setopt hist_reduce_blanks
# 履歴をインクリメンタルに追加
setopt inc_append_history
# 全履歴を一覧表示
function history-all { history -E 1 }
# インクリメンタルからの検索
bindkey "^A" history-incremental-search-backward

# コマンドを途中まで入力後,historyから絞り込み(挙動をいまいち分かっていない...)
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end



# -----------------------------------
# zsh auto suggestion extension
# -----------------------------------
# 入力中の文字に応じて履歴からコマンド候補を表示
ZSH_AUTOSUGGEST1=~/.zsh/zsh-autosuggestions
ZSH_AUTOSUGGEST2=${ZSH_AUTOSUGGEST1}/zsh-autosuggestions.zsh
if [ -d ${ZSH_AUTOSUGGEST1} ]; then
    source ${ZSH_AUTOSUGGEST2}
else
    echo "File doesn't exist."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_AUTOSUGGEST1}
    source ${ZSH_AUTOSUGGEST2}
fi
# Ctrl+f で表示中サジェストを確定
bindkey -v '^f' autosuggest-accept  # for insert mode
bindkey -a '^f' autosuggest-accept  # for normal mode
bindkey '^ ' autosuggest-accept
# 色の設定
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=103'
# 色確認用ワンライナー
# for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo


# 例) Ctrl + Dで文字列削除
# ref : https://orebibou.com/ja/home/201811/20181108_001/
function __zsh_clean_line() {
    # 入力されている文字列を変数$BUFに代入
    local BUF=${BUFFER}
    # 入力されている文字列を削除
    zle kill-whole-line
}
# functionをキーバインドで利用できるよう読み込ませる
zle -N __zsh_clean_line
# キーバインドの設定
bindkey '^D' __zsh_clean_line

# コマンドラインのベース設定
# コマンドラインの操作UIをemacs ライクに変更(デフォルト)
bindkey -e
# コマンドラインの操作UIをvi ライクに変更
# bindkey -v

# ------------------------------
# Prompt
# 現在は,viは止めてデフォルトのモードを使用
# ------------------------------
# viモードで現在の入力モードをプロンプトに表示
function zle-line-init zle-keymap-select {
# 色定義
# MAIN_COLOR="%{${fg[cyan]}%}"
# VI_NORMAL="%{${fg[green]}%}"
# VI_INSERT="%{${fg[blue]}%}"
WHITE="%{${fg[white]}%}"
RED="%{${fg[red]}%}"
GREEN="%{${fg[green]}%}"
RESET="%{${reset_color}%}"

# venv/conda環境を表示
_VENV=""
if [ -n "${VIRTUAL_ENV}" ]; then
    _VENV="${GREEN}[VENV:$(basename "$VIRTUAL_ENV")] ${RESET}"
elif [ -n "${CONDA_DEFAULT_ENV}" ]; then
    _VENV="${GREEN}[CONDA:${CONDA_DEFAULT_ENV}] ${RESET}"
fi

# クライアントPCのIP Addressのみ取得
CLIENT_IP=$(cut -d' ' -f 1 <<<${SSH_CONNECTION})
# SSH情報追加
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && _SSH="$RED""[SSH] ${CLIENT_IP} -> "

# デフォルトの設定(太字)
_HOST="${fg[yellow]}%}"%B"${HOST}"%b"[%~]"

# ホストごとに定義している場合は表示内容を変更(太字)
# (ユーザ名@ホスト名にしたい場合:"%n@%m", カレントディレクトリ:"%~", %B %bで囲むと範囲内を太字化)
case ${HOST} in
    "FOO")  _HOST="${fg[yellow]}%}"%B"foooo"%b"[%~]" ;;
    "BAR")  _HOST="${fg[magenta]}%}"%B"baaar"%b"[%~]" ;;
esac
# # viモード表示追加(現在は使っていない)
# case $KEYMAP in
#     vicmd)      _VI_MODE=$WHITE"["$VI_NORMAL"NORMAL"$WHITE"]" ;;
#     main|viins) _VI_MODE=$WHITE"["$VI_INSERT"INSERT"$WHITE"]" ;;
# esac
# # 改行追加(太字)
# _N=$WHITE"
# %B${_VI_MODE}%b > "
_N=$WHITE"
%b> "

# プロンプトに設定
PROMPT=${_VENV}${_SSH}${_HOST}${_N}

zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select



# ------------------------------
# Git Status Prompt (行 右側に表示)
# ------------------------------
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{014}(%b)%r[git]%f'
zstyle ':vcs_info:*' enable git



# ------------------------------
# Alias
# ------------------------------

# :::::::::::::::::::::::::::::::::::::
# ::::: OS 別設定 :::::
case ${OSTYPE} in
    darwin*) export CLICOLOR=1; alias ls='ls -G -F' ;;
    linux*) alias ls='ls -F --color=auto' ;;
esac

# :::::::::::::::::::::::::::::::::::::
# ::::: ホスト別設定 :::::
case ${HOST} in
    "FOO")
        _DROPBOX="/Users/foobar/Dropbox"
        ;;
    "BAR")
        _DROPBOX="/mnt/c/Users/barfoo/Dropbox"
        alias cdc='cd /mnt/c/Users/barfoo/'
        ;;
esac

# :::::::::::::::::::::::::::::::::::::
# ::::: 全端末共通設定

alias l='ls -lh'
alias ll='ls -lha'
alias vi='vi -u NONE -N'
alias df='df -h'
alias use='du -d 1 -h'
alias c='clear'
alias axel='axel -a -n 10'
alias smi='nvidia-smi -l 1'

# python エンコードをUTF-8に固定(参考 : https://github.com/trac-hacks/tracsql/issues/3)
export PYTHONIOENCODING=utf-8

# git diff や git status などの日本語メッセージ文字化けを対策 https://maku77.github.io/git/settings/garbling.html
export GIT_PAGER="LESSCHARSET=utf-8 less"
git config --global core.quotepath false

# :::::::::::::::::::::::::::::::::::::
# ::::: 端末共通設定(未検証)
# git更新履歴を表示
alias gitlog='git log --oneline --graph --all'
#ディレクトリ構成表示
alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/| /g'"
# vim(or neoivm)の起動速度測定(vs default setting)
function measureSpeedVim() { command echo "scale=3; $(vim --startuptime /tmp/stime_mine.log -c 'quit' > /dev/null && tail -n 1 /tmp/stime_mine.log | cut -d ' ' -f1) / $(vi -u DEFAULTS --startuptime /tmp/stime_def.log -c 'quit' > /dev/null && tail -n 1 /tmp/stime_def.log | cut -d ' ' -f1)" | bc | xargs -i echo {}x slower your Vim than the default. }
function measureSpeedNeovim() { echo "scale=3; $(nvim --startuptime /tmp/stime_mine.log -c 'quit' > /dev/null && tail -n 1 /tmp/stime_mine.log | cut -d ' ' -f1) / $(vi -u DEFAULTS --startuptime /tmp/stime_def.log -c 'quit' > /dev/null && tail -n 1 /tmp/stime_def.log | cut -d ' ' -f1)" | bc | xargs -i echo {}x slower your Vim than the default. }


# ------------------------------
# SSH
# ------------------------------
# 基本的には ~/.ssh/config に記述してあるホストを参照するようにすれば，
# scp や rsync などで別のホストを指定するときパス補完が働く．
var_ssh_ip='foobar@hoge.fuga.ac.jp'
alias scope='ssh $var_ssh_ip'

# -----------------------------------
# Ignore case completion
# -----------------------------------
if grep 'set completion-ignore-case on' ~/.inputrc >/dev/null; then
    # echo "pattern exist"
    echo 'set completion-ignore-case on' > ~/.inputrc
else
    # echo "pattern does not exist"
    echo 'set completion-ignore-case on' >> ~/.inputrc
fi


# ------------------------------
# LaTeX
# ------------------------------
# bibtex使わないバージョン
function myplatex()
{
    TEX_FILE=$1
    FILE=${TEX_FILE%.*}
    DVI_FILE=${FILE}.dvi
    command platex ${TEX_FILE}
    command platex ${TEX_FILE}
    command dvipdfmx ${DVI_FILE}
    rm -f ${FILE}.aux ${FILE}.log ${FILE}.synctex.gz ${FILE}.dvi texput.log
}

# bibtex使うバージョン
function mybibplatex()
{
    TEX_FILE=$1
    FILE=${TEX_FILE%.*}
    DVI_FILE=${FILE}.dvi
    command platex ${TEX_FILE}
    command pbibtex ${FILE}
    command platex ${TEX_FILE}
    command platex ${TEX_FILE}
    command dvipdfmx ${DVI_FILE}
    command rm -f ${FILE}.aux ${FILE}.log ${FILE}.synctex.gz ${FILE}.dvi texput.log
}


# -----------------------------------
# tmux plugin manager install
# -----------------------------------
# tmux plugin manager が存在しなければインストールする(gitと~/.tmux.confとの連携が前提)
TPM_MANAGER=~/.tmux/plugins/tpm
if [ -d ${TPM_MANAGER} ]; then
    :
else
    echo "${TPM_MANAGER} is doesn't found. Start installing TPM."
    git clone https://github.com/tmux-plugins/tpm ${TPM_MANAGER}
fi

