" fzf.vim 設定

" FZF用PATH (deinでインストールされたfzf)
let s:fzf_bin_dir = expand('~/.vim/dein/repos/github.com/junegunn/fzf/bin')
if isdirectory(s:fzf_bin_dir)
    let $PATH .= ':' . s:fzf_bin_dir
endif

" キーマップ
nnoremap <Leader>a :Rg<CR>
nnoremap <Leader>s :BLines<CR>
nnoremap <Leader>d :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>w :Marks<CR>
nnoremap <Leader>q :History<CR>
imap <C-f> <plug>(fzf-complete-path)

" ウィンドウ設定
augroup fzf
    autocmd!
    autocmd! FileType fzf
    au FileType fzf tnoremap <Leader><Leader> <ESC>
augroup END

let g:fzf_buffers_jump = 1
let g:fzf_layout = {'down': '~40%'}

" ファイル展開方法
let g:fzf_action = {
\ 'ctrl-t': 'tab split',
\ 'ctrl-s': 'split',
\ 'ctrl-v': 'vsplit',
\ }
