"
" vimrc for Vim8
"
if has('win32')                   " Windows 32bit または 64bit ?
  set encoding=cp932              " cp932 が嫌なら utf-8 にしてください
else
  set encoding=utf-8
endif
scriptencoding utf-8              " This file's encoding

" 推奨設定の読み込み (:h default.vim)
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

"===============================================================================
" 設定の追加はこの行以降でおこなうこと！
" 分からないオプション名は先頭に ' を付けてhelpしましょう。例:
" :h 'helplang

set helplang=ja,en                " help言語の設定

set number

set scrolloff=0
set laststatus=2                  " 常にステータス行を表示する
set cmdheight=2                   " hit-enter回数を減らすのが目的
if !has('gui_running')            " gvimではない？ (== 端末)
  set mouse=                      " マウス無効 (macOS時は不便かも？)
  set ttimeoutlen=0               " モード変更時の表示更新を最速化
  if $COLORTERM == "truecolor"    " True Color対応端末？
    set termguicolors
  endif
endif
set nofixendofline                " Windowsのエディタの人達に嫌われない設定
set ambiwidth=double              " ○, △, □等の文字幅をASCII文字の倍にする
set directory-=.                  " swapファイルはローカル作成がトラブル少なめ
set formatoptions+=mM             " 日本語の途中でも折り返す
set autowrite                     " :make 時に自動保存
let &grepprg="grep -rnIH --exclude=.git --exclude-dir=.hg --exclude-dir=.svn --exclude=tags"
let loaded_matchparen = 1         " カーソルが括弧上にあっても括弧ペアをハイライトさせない
let mapleader = ","               " leader を , に変更

" :grep 等でquickfixウィンドウを開く (:lgrep 等でlocationlistウィンドウを開く)
"augroup qf_win
"  autocmd!
"  autocmd QuickfixCmdPost [^l]* copen
"  autocmd QuickfixCmdPost l* lopen
"augroup END

" マウスの中央ボタンクリックによるクリップボードペースト動作を抑制する
noremap <MiddleMouse> <Nop>
noremap! <MiddleMouse> <Nop>
noremap <2-MiddleMouse> <Nop>
noremap! <2-MiddleMouse> <Nop>
noremap <3-MiddleMouse> <Nop>
noremap! <3-MiddleMouse> <Nop>
noremap <4-MiddleMouse> <Nop>
noremap! <4-MiddleMouse> <Nop>

"-------------------------------------------------------------------------------
" ステータスライン設定
let &statusline = "%<%f %m%r%h%w[%{&ff}][%{(&fenc!=''?&fenc:&enc).(&bomb?':bom':'')}] "
if has('iconv')
  let &statusline .= "0x%{FencB()}"

  function! FencB()
    let c = matchstr(getline('.'), '.', col('.') - 1)
    if c != ''
      let c = iconv(c, &enc, &fenc)
      return s:Byte2hex(s:Str2byte(c))
    else
      return '0'
    endif
  endfunction
  function! s:Str2byte(str)
    return map(range(len(a:str)), 'char2nr(a:str[v:val])')
  endfunction
  function! s:Byte2hex(bytes)
    return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
  endfunction
else
  let &statusline .= "0x%B"
endif
let &statusline .= "%=%l,%c%V %P"

"-------------------------------------------------------------------------------
" ファイルエンコーディング検出設定
let &fileencoding = &encoding
if has('iconv')
  if &encoding ==# 'utf-8'
    let &fileencodings = 'iso-2022-jp,euc-jp,cp932,' . &fileencodings
  else
    let &fileencodings .= ',iso-2022-jp,utf-8,ucs-2le,ucs-2,euc-jp'
  endif
endif
" 日本語を含まないファイルのエンコーディングは encoding と同じにする
if has('autocmd')
  function! AU_ReSetting_Fenc()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding = &encoding
    endif
  endfunction
  augroup resetting_fenc
    autocmd!
    autocmd BufReadPost * call AU_ReSetting_Fenc()
  augroup END
endif

"-------------------------------------------------------------------------------
" プラグイン

call plug#begin('~/.vim/plugged')
Plug 'vim-jp/vimdoc-ja'

" Theme
Plug 'jdkanani/vim-material-theme'

" NERDTree
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

Plug 'maralla/completor.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'godlygeek/tabular'
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-surround'
Plug 'fatih/vim-go'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Markdown
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'kannokanno/previm'
Plug 'tyru/open-browser.vim'

" Json
Plug 'elzr/vim-json'

" Yaml
Plug 'avakhov/vim-yaml'

Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'

call plug#end()

"-------------------------------------------------------------------------------
" Color Sheme
syntax enable
set background=dark
colorscheme material-theme

" Go completion
let g:completor_gocode_binary = "${GOPATH}/bin/gocode"

" Tagbar
let g:tagbar_autofocus = 1

" NERDTree
let NERDTreeShowHidden=1
map <C-e> <plug>NERDTreeTabsToggle<CR>

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" vim-go
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
let g:go_fmt_command = "goimports"
let g:go_textobj_include_function_doc = 0
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_build_constraints = 1
let g:go_test_timeout = '10s'
let g:go_metalinter_autosave = 1
let g:go_metalinter_deadline = "5s"
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
autocmd FileType go nmap <Leader>i <Plug>(go-info)
let g:go_auto_type_info = 1
set updatetime=100
let g:go_auto_sameids = 1

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" terraform
let g:terraform_fmt_on_save = 1

" 行末のスペースを取り除く
autocmd BufWritePre * :%s/\s\+$//ge

" vim:set et ts=2 sw=0: