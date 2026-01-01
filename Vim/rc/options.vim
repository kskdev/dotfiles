" Vim base options - 基本設定
" エンコーディング，表示，インデント等の基本設定

" macOS Homebrew環境でfzf/ripgrepを利用可能にするためのPATH設定
if has('mac')
    if isdirectory('/opt/homebrew/bin')
        let $PATH = '/opt/homebrew/bin:' . $PATH
    endif
    if isdirectory('/usr/local/bin')
        let $PATH = '/usr/local/bin:' . $PATH
    endif
endif

" vim起動時にReplace Modeで起動されてしまう現象の対策
set t_u7=
set t_RV=

" 基本設定
set backspace=start,eol,indent
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set fileformats=unix,dos,mac
set noswapfile
set nobackup
set noundofile

" 表示設定
highlight Normal ctermbg=none
set ambiwidth=double
let g:tex_conceal = ''

" カーソル位置復元
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" 表示UI
set number
set ruler
set cursorline
set showmatch
set matchtime=1
set showcmd
set noshowmode
set cmdheight=1
set scrolloff=3
set laststatus=2
set notitle
set signcolumn=yes

" 検索設定
set hlsearch
set ignorecase
set incsearch
nnoremap <silent><ESC> :nohlsearch<CR>

" インデント設定
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent

" 言語別インデント
augroup fileTypeIndent
    autocmd!
    au BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    au BufNewFile,BufRead *.js setlocal tabstop=4 softtabstop=4 shiftwidth=4
    au BufNewFile,BufRead *.ts setlocal tabstop=4 softtabstop=4 shiftwidth=4
    au BufNewFile,BufRead *.jsx setlocal tabstop=4 softtabstop=4 shiftwidth=4
    au BufNewFile,BufRead *.tsx setlocal tabstop=4 softtabstop=4 shiftwidth=4
    au BufNewFile,BufRead *.sh setlocal tabstop=2 softtabstop=2 shiftwidth=2
    au BufNewFile,BufRead *.zsh setlocal tabstop=2 softtabstop=2 shiftwidth=2
    au BufNewFile,BufRead *.bash setlocal tabstop=2 softtabstop=2 shiftwidth=2
    au BufNewFile,BufRead *.vim setlocal tabstop=2 softtabstop=2 shiftwidth=2
    au BufNewFile,BufRead *.tex setlocal tabstop=2 softtabstop=2 shiftwidth=2
    au BufNewFile,BufRead *.xml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    au BufNewFile,BufRead *.json setlocal tabstop=2 softtabstop=2 shiftwidth=2
    au BufNewFile,BufRead *.yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    au BufNewFile,BufRead *.html setlocal tabstop=1 softtabstop=1 shiftwidth=1
augroup END

" 補完設定
set wildmenu
set wildignorecase
set wildmode=list,full

" キーマップ基本
let mapleader = "\<Space>"
inoremap <C-x><C-f> <C-X><C-F><C-P>
inoremap <C-l> <Right>
set timeoutlen=500
set ttimeoutlen=10
nnoremap <C-w> <C-w><C-w>
set whichwrap=b,s,<,>,[,],h,l

" jj でノーマルモードへ (fcitx対応)
if executable('fcitx-remote')
    inoremap jj <ESC>:call system('fcitx-remote -c')<CR>
    inoremap っｊ <ESC>:call system('fcitx-remote -c')<CR>
else
    inoremap jj <ESC>
    inoremap っｊ <ESC>
endif
