"##########################
"##    dein.vimの設定   ###
"##########################
if &compatible
  set nocompatible
endif

let s:dein_dir = expand('~/.config/nvim/dein')
let s:dein_repo_dir = s:dein_dir .'/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

" プラグインリストを収めたTOMLファイル
  let s:toml = s:dein_dir . '/dein.toml'
  let s:lazy_toml = s:dein_dir . '/dein_lazy.toml'
  let s:neo_toml = s:dein_dir . '/dein_neo.toml'

" TOMLファイルにpluginを記述
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
"  if has('nvim')
"      call dein#load_toml(s:neo_toml,{'lazy':1})
"  endif


  call dein#end()
  call dein#save_state()
endif

" 未インストールを確認
if dein#check_install()
  call dein#install()
endif

"##########################
"###    vim settings    ###
"##########################
set background=dark
" colorscheme solarized
" colorscheme molokai
colorscheme gruvbox
" colorscheme monokai
set t_Co=256
syntax on
set number
set relativenumber
set list
set listchars=tab:>>,trail:-,nbsp:%,eol:↲
set expandtab
set autoindent
set shiftwidth=4
set colorcolumn=80    "set line on 80 chars

set cursorline
set cursorcolumn

hi ColorColumn guibg=#444444 "set line color
filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins
filetype plugin indent on
" let python_highlight_all = 1
" configured on plugins

set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set ambiwidth=double " □や○文字が崩れる問題を解決

" fix delay on escape
" When you’re pressing Escape to leave insert mode in the terminal, it will by
" default take a second or another keystroke to leave insert mode completely
" and update the statusline. This fixes that. I got this from:
" https://powerline.readthedocs.org/en/latest/tipstricks.html#vim
if !has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set ttimeoutlen=50
    augroup END
endif


"###括弧の自動補完の設定を入れてみる###
" inoremap { {}<LEFT>
" inoremap ( ()<LEFT>
" inoremap [ []<LEFT>

" launch NERDTree
autocmd vimenter * NERDTree

"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"プラグイン関連
"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"let g:syntastic_python_checkers = ["flake8"] "syntastic

"autocmd FileType python setlocal omnifunc=jedi#completions

"jedi-vimとneocompleteの食合せの調整
"http://kozo2.hatenablog.com/entry/2014/01/22/050714
"let g:jedi#popup_select_first=0
"let g:jedi#completions_enabled = 0
"let g:jedi#auto_vim_configuration = 0
"let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'])    "イコール以降に問題
