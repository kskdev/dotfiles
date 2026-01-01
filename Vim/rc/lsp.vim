" vim-lsp 設定
let g:lsp_auto_enable = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_priority = 10
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_virtual_text_enabled = 0
let g:lsp_preview_float = 1
let g:lsp_highlights_enabled = 0
let g:lsp_preview_autoclose = 1
let g:lsp_preview_keep_focus = 1

" 左端記号の表示設定
let g:lsp_diagnostics_signs_enabled = 1
let g:lsp_diagnostics_signs_error = {'text': 'X'}
let g:lsp_diagnostics_signs_warning = {'text': '!'}
let g:lsp_diagnostics_signs_information = {'text': 'i'}
let g:lsp_diagnostics_signs_hint = {'text': '?'}

" sign と virtual text の色定義
augroup vimlsp_colors
    autocmd!
    au ColorScheme * :hi LspErrorText ctermfg=9 guifg=red ctermbg=235
    au ColorScheme * :hi LspWarningText ctermfg=214 guifg=orange ctermbg=235
    au ColorScheme * :hi LspInformationText ctermfg=gray guifg=gray ctermbg=235
    au ColorScheme * :hi LspHintfomationText ctermfg=cyan guifg=cyan ctermbg=235
augroup END

" LSP機能キーマップ
nnoremap gh :LspHover<CR>
nnoremap gd :LspDefinition<CR>
nnoremap gr :LspRename<CR>
