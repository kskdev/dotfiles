" lightline.vim 設定

set showtabline=2

let g:lightline = {'separator': {'left': '', 'right': ''}, 'subseparator': {'left': '','right': ''}, 'mode_map': {'c': 'NORMAL'},}

" component 定義
let g:lightline.component           = {}
let g:lightline.component.dir       = '%.35(%{expand("%:h:s?\\S$?\\0/?")}%)'
let g:lightline.component.winbufnum = '%n%{repeat(",", winnr())}%<'
let g:lightline.component.rows      = '%L'
let g:lightline.component.cd        = '%.35(%{fnamemodify(getcwd(), ":~")}%)'
let g:lightline.component.tabopts   = '%{&et?"et":""}%{&ts}:%{&sw}:%{&sts},%{&tw}'
let g:lightline.component.lineinfo  = '%l/%L'

" component_function 定義
let g:lightline.component_function                = {}
let g:lightline.component_function.modified       = 'LightlineModified'
let g:lightline.component_function.readonly       = 'LightlineReadonly'
let g:lightline.component_function.fugitive       = 'LightlineFugitive'
let g:lightline.component_function.filename       = 'LightlineFilename'
let g:lightline.component_function.fileformat     = 'LightlineFileformat'
let g:lightline.component_function.filetype       = 'LightlineFiletype'
let g:lightline.component_function.fileencoding   = 'LightlineFileencoding'
let g:lightline.component_function.mode           = 'LightlineMode'
let g:lightline.component_function.lsp            = 'LspServerStatusForStatusLine'

" component_expand 定義
let g:lightline.component_expand            = {}
let g:lightline.component_expand.buffers    = 'lightline#bufferline#buffers'

" component_type 定義
let g:lightline.component_type            = {}
let g:lightline.component_type.buffers    = 'tabsel'
let g:lightline.component_type.lsp        = 'right'

" ステータスラインフォーマット
let g:lightline.active         = {}
let g:lightline.active.left    = [['mode', 'paste'], ['fugitive'], ['filename', 'readonly']]
let g:lightline.active.right   = [['lsperror'], ['lspwarning'], ['lsp'], ['lineinfo']]
let g:lightline.inactive       = {}
let g:lightline.inactive.left  = [['mode', 'paste'], ['fugitive'], ['filename', 'readonly']]
let g:lightline.inactive.right = [['lineinfo']]
let g:lightline.tabline = {}
let g:lightline.tabline = {'left': [ ['buffers'] ], 'right': [ ['fileformat'], ['fileencoding'], ['filetype'], ['cd'] ]}

" component 関数定義
function! LightlineModified()
    return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
    return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightlineFilename()
    return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
        return fugitive#head()
    else
        return ''
    endif
endfunction

function! LightlineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
    return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
    return winwidth(0) > 40 ? lightline#mode() : ''
endfunction

function! LspServerStatusForStatusLine()
    return g:lsp#get_server_status()
endfunction

function! LspWarningNum()
    let s:warning_num = lsp#get_buffer_diagnostics_counts()['warning']
    return s:warning_num == 0 ? '' : 'Warning:' . s:warning_num
endfunction

function! LspErrorNum()
    let s:error_num = lsp#get_buffer_diagnostics_counts()['error']
    return s:error_num == 0 ? '' : 'Error:' . s:error_num
endfunction

" カラー定義 (iceberg仕様)
command! -bar LightLineUpdate call lightline#init()| call lightline#colorscheme()| call lightline#update()

let g:lightline.colorscheme = 'mypalette'
let g:pltt = {'inactive': {}, 'normal': {}, 'insert': {}, 'visual': {}, 'replace': {}, 'tabline': {}}

let s:base_0 = ['#c6c8d1', '#1e2132', 252, 235]
let s:base_1 = ['#1e2132', '#c6c8d1', 235, 252]
let s:base_2 = ['#c6c8d1', '#1e2132', 252, 235]

let s:mode_stl = ['#e27878', '#1e2132', 203, 235]
let s:mode_nor = ['#282828', '#84a0c6', 235, 110]
let s:mode_ins = ['#282828', '#a093c7', 235, 140]
let s:mode_vis = ['#282828', '#e2a478', 235, 216]
let s:mode_rep = ['#282828', '#818596', 235, 234]
let s:mode_war = ['#e2a478', '#1e2132', 216, 236]
let s:mode_err = ['#e27878', '#1e2132', 203, 236]

let s:tab_f = ['#a093c7', '#161821', 140, 234]
let s:tab_b = ['#c6c8d1', '#1e2132', 252, 235]

let g:STL_BASECOLOR = s:base_0
let g:STL_ATTRIBUTECOLOR = s:base_1

let g:pltt.inactive.middle = [g:STL_BASECOLOR]
let g:pltt.inactive.left = [s:mode_stl, ]
let g:pltt.inactive.right = [g:STL_BASECOLOR]
let g:pltt.normal.middle = [g:STL_BASECOLOR]
let g:pltt.normal.left = [s:mode_nor, ]
let g:pltt.normal.right = deepcopy(g:pltt.inactive.right)
let g:pltt.insert.middle = [g:STL_BASECOLOR]
let g:pltt.insert.left = [s:mode_ins, ]
let g:pltt.insert.right = deepcopy(g:pltt.inactive.right)
let g:pltt.visual.middle = [g:STL_BASECOLOR]
let g:pltt.visual.left = [s:mode_vis, ]
let g:pltt.visual.right = deepcopy(g:pltt.inactive.right)
let g:pltt.replace.middle = [g:STL_BASECOLOR]
let g:pltt.replace.left = [s:mode_rep, ]
let g:pltt.replace.right = deepcopy(g:pltt.inactive.right)
let g:pltt.tabline.middle = [s:base_2]
let g:pltt.tabline.left = [s:tab_b]
let g:pltt.tabline.right = [s:base_2, ]
let g:pltt.tabline.tabsel = [s:tab_f]
let g:pltt.normal.warning = [s:mode_war]
let g:pltt.normal.error   = [s:mode_err]

let g:lightline#colorscheme#mypalette#palette = g:pltt
unlet g:pltt g:STL_BASECOLOR g:STL_ATTRIBUTECOLOR

" lightline-bufferline 設定
let g:lightline#bufferline#show_number = 0
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed = '[E]'
let g:lightline#bufferline#filename_modifier = '%f'
