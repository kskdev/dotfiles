" fern.vim 設定

function! s:fern_init() abort
  let g:fern#disable_viewer_hide_cursor = 1
  nnoremap <buffer> <silent> q :q<CR>
  nnoremap <buffer> <silent> <C-n> :q<CR>
  map <buffer> <silent> <C-x> <Plug>(fern-action-open:split)
  map <buffer> <silent> <C-v> <Plug>(fern-action-open:vsplit)
  map <buffer> <silent> y <Plug>(fern-action-yank:path)
  map <buffer> <silent> c <Plug>(fern-action-copy)
  map <buffer> <silent> m <Plug>(fern-action-move)
  map <buffer> <silent> d <Plug>(fern-action-new-dir)
  map <buffer> <silent> f <Plug>(fern-action-new-file)
  map <buffer> <silent> x <Plug>(fern-action-remove)
  map <buffer> <silent> h <Plug>(fern-action-hidden:toggle)
  map <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  map <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
endfunction

augroup fern-setteings
  au!
  au FileType fern call s:fern_init()
augroup END
