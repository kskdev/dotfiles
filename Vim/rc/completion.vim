" ddc.vim 補完設定

" source の登録
call ddc#custom#patch_global('sources', ['vim-lsp','file','around','cmdline_history','cmdline'])

" sourceに関する設定
call ddc#custom#patch_global('sourceOptions', {
\ '_': {
\   'matchers': ['matcher_fuzzy'],
\   'sorters': ['sorter_fuzzy'],
\   'converters': ['converter_fuzzy'],
\   'ignoreCase': v:true,
\   'minAutoCompleteLength': 1,
\   'timeout': 1000,
\ },
\ 'vim-lsp': {
\   'mark': ' LSP', 
\   'minAutoCompleteLength': 1,
\   'forceCompletionPattern': '\.|:|->\|"\w+/*',
\   'timeout': 2000,
\ },
\ 'file': {
\   'mark': 'FILE',
\   'minAutoCompleteLength': 1,
\   'isVolatile': v:true, 
\   'forceCompletionPattern': '\S/\S*',
\   'timeout': 1000,
\ },
\ 'around': {
\   'mark': 'ARND',
\   'minAutoCompleteLength': 2,
\ },
\ 'cmdline': {
\   'mark': ' CMD',
\   'minAutoCompleteLength': 1,
\   'timeout':  500,
\ },
\ 'cmdline_history': {
\   'mark': 'HIST',
\   'minAutoCompleteLength': 1,
\   'timeout':  500,
\ },
\ 'necovim': {
\   'mark': 'vim',
\ },
\
\ })

call ddc#custom#patch_global('filterParams', {
\   'converter_fuzzy': {
\   'hlGroup': 'SpellBad'
\ }
\
\ })

call ddc#custom#patch_global('sourceParams', #{
\   around: #{ maxSize    : 128     },
\   file  : #{ disableMenu: v:true, },
\ })

" 補完候補表示UI設定はコマンドライン補完設定に含まれる

" pum.vimキーマップ
inoremap <expr><TAB> ddc#visible() ? "\<Cmd>call pum#map#insert_relative(+1)<CR>" : "\<TAB>"
inoremap <expr><S-TAB> ddc#visible() ? "\<Cmd>call pum#map#insert_relative(-1)<CR>" : ""

" コマンドライン補完設定
call ddc#custom#patch_global(#{
\   ui: 'pum',
\   autoCompleteEvents: [
\     'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged',
\   ],
\   cmdlineSources: {
\     ':': ['cmdline_history','cmdline','around', 'file'],
\   },
\ })
nnoremap :       <Cmd>call CommandlinePre()<CR>:

if !exists('*CommandlinePre')
    function! CommandlinePre() abort
        call ddc#custom#patch_buffer('sources',['cmdline_history','cmdline','file','around'])
        cnoremap <Tab>   <Cmd>call pum#map#insert_relative(+1)<CR>
        cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
        cnoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
        cnoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
        cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
        cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
        autocmd User DDCCmdlineLeave ++once call CommandlinePost()
        call ddc#enable_cmdline_completion()
    endfunction
endif

if !exists('*CommandlinePost')
    function! CommandlinePost() abort
        silent! cunmap <Tab>
        silent! cunmap <S-Tab>
        silent! cunmap <C-n>
        silent! cunmap <C-p>
        silent! cunmap <C-y>
        silent! cunmap <C-e>
    endfunction
endif

" ファイルタイプ別設定
call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'])
call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', { 'clangd': {'mark': 'C'}, })
call ddc#custom#patch_filetype(['vim', 'toml'], 'sources', ['necovim','file','around','cmdline_history','cmdline'])

" ddc 有効化
call ddc#enable()
