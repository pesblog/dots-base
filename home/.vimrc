set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/vundle.git/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
" original repos on github
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'othree/html5.vim'
Bundle 'css3-syntax-plus'
Bundle 'msanders/snipmate.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'surround.vim'
Bundle 'thinca/vim-qfreplace'
Bundle 'thinca/vim-poslist'
Bundle 'houtsnip/vim-emacscommandline'
Bundle 'tpope/vim-surround'
Bundle 'rosstimson/scala-vim-support'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-markdown'

" vim-scripts repos
Bundle 'YankRing.vim'

" non github repos

filetype plugin indent on     " required!

:source $VIMRUNTIME/macros/matchit.vim
let b:match_words = "if:endif,foreach:endforeach,\<begin\>:\<end\>"

" インデントを2にして、タブ文字は4文字のままにする（わざと崩れて表示させる）
set expandtab tabstop=4 shiftwidth=2
"set tabstop=4 shiftwidth=4 softtabstop=4

" 連続コピペ出来ない問題の解決
" http://qiita.com/items/bd97a9b963dae40b63f5
vnoremap <silent> <C-p> "0p<CR>

" ビープ音消す
set visualbell t_vb=

" 検索結果に移動したとき、その位置を画面の中央に
"nnoremap n nzz
"nnoremap N Nzz
"nnoremap * *zz
"nnoremap # #zz
"nnoremap g* g*zz
"nnoremap g# g#zz

" http://nanasi.jp/articles/vim/commentout_source.html
vmap ,# :s/^/#/<CR>:nohlsearch<CR>
vmap ,/ :s/^/\/\//<CR>:nohlsearch<CR>
vmap ,> :s/^/> /<CR>:nohlsearch<CR>
vmap ," :s/^/\"/<CR>:nohlsearch<CR>
vmap ,% :s/^/%/<CR>:nohlsearch<CR>
vmap ,! :s/^/!/<CR>:nohlsearch<CR>
vmap ,; :s/^/;/<CR>:nohlsearch<CR>
vmap ,- :s/^/--/<CR>:nohlsearch<CR>
vmap ,c :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR>:nohlsearch<CR>

" wrapping comments
vmap ,* :s/^\(.*\)$/\/\* \1 \*\//<CR>:nohlsearch<CR>
vmap ,( :s/^\(.*\)$/\(\* \1 \*\)/<CR>:nohlsearch<CR>
vmap ,< :s/^\(.*\)$/<!-- \1 -->/<CR>:nohlsearch<CR>
vmap ,d :s/^\([/(]\*\\|<!--\) \(.*\) \(\*[/)]\\|-->\)$/\2/<CR>:nohlsearch<CR> 

" block comments
vmap ,b v`<I<CR><esc>k0i/*<ESC>`>j0i*/<CR><esc><ESC>
vmap ,h v`<I<CR><esc>k0i<!--<ESC>`>j0i--><CR><esc><ESC>

" place for backup files.
set backupdir=~/work/tmp
set directory=~/work/tmp

" NERDTree command
command NTT NERDTreeToggle
" NERDTree
nnoremap U :NERDTreeToggle<CR>
" 隠しファイルを表示
let NERDTreeShowHidden = 1

" expand path
cmap <c-x> <c-r>=expand('%:p:h')<cr>/
" expand file (not ext)
cmap <c-z> <c-r>=expand('%:p:r')<cr>

" コーディングスタイル定義
let s:coding_styles = {}
let s:coding_styles['default']      = 'set expandtab   tabstop=2 shiftwidth=2 softtabstop=2'
let s:coding_styles['dev']         = 'set noexpandtab tabstop=4 shiftwidth=4 softtabstop=4'

command!
\   -bar -nargs=1 -complete=customlist,s:coding_style_complete
\   CodingStyle
\   execute get(s:coding_styles, <f-args>, '')

function! s:coding_style_complete(...) "{{{
    return keys(s:coding_styles)
endfunction "}}}

" デフォルトコーディングスタイル
nnoremap <Space>r :<C-u>execute "source " expand("%:p")<CR>

" Ctrl-A で数字をインクリメントするとき、先頭が 0 でも8進数として扱わない。
set nrformats-=octal

function! Caniuse()
  let s:line = getline(".")
  let s:css = substitute(substitute(substitute(getline("."), '^ *', "", "g" ), ':.*$', "", "g" ), '^-webkit-\|-moz-\|-ms-\|', "", "g" )
  "let s:css = matchstr( s:css , '[^ ]*[a-z-]*[^:]')
  echo s:line
  echo s:css
  if s:css != ""
    exec "!open \"http://caniuse.com/\\#search=" . s:css . "\""
  else
    echo "No CSS found in line."
  endif
endfunction

map <Leader>w :call Caniuse()<CR>

" poslist.vim settings.
map <C-o> <Plug>(poslist-prev-pos)
map <C-i> <Plug>(poslist-next-pos)
map <C-O> <Plug>(poslist-prev-buf)
map <C-I> <Plug>(poslist-next-buf)
let g:poslist_histsize = 1000

" ペーストしたテキストを選択する
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" YankRing.vim settings.
let g:yankring_history_dir = '~/work/tmp/'
let g:yankring_history_file = '.yankring_history'

" インデント変更しても選択を外れないように
vnoremap < <gv
vnoremap > >gv

let g:returnApp = "MacVim"

" for coffee-script
nnoremap <silent> <C-C> :CoffeeCompile vert <CR><C-w>h
setlocal splitright

function! k:Now()
  let now = "\n----------------------------------------------------------------------\n"
  let now = now . system("LANG=C date +'[%Y-%m-%d %H:%M:%S]'")
  execute ":normal i" . now
  execute ":startinsert"
endfunction
command! Now call k:Now()

function! k:Memo(diff)
  "edit `=system("memo_filename")`
  execute ":edit " . system("memo_filename " . a:diff)
endfunction
command! -nargs=0 Memo call k:Memo("")
command! -nargs=* Memox call k:Memo(<f-args>)

function! s:MemoEnter(argc)
  if a:argc == 0
    call k:Memo("")
    execute ":set filetype=mkd"
    execute ":normal zr zr"
    execute ":cd %:h"
    execute ":NERDTreeCWD"
    execute ":wincmd \<C-W>"
  end
endfunction

function! s:MkdOpen()
  execute ":normal zr zr"
endfunction

" MacVimを開いた直後にその日のメモを開く
autocmd VimEnter * call s:MemoEnter(argc())
autocmd BufRead,BufNewFile *.md call s:MkdOpen()

function! k:QL()
  let a = escape(expand("%:p"), " ()")
  let b = system("open -a MarkdownPreviewer.app " . a)
endfunction
command! QL call k:QL()

function! k:Memod()
  let a = escape(expand("%:h"), " ()")
  execute ":edit " . a
endfunction
command! Memod call k:Memod()

" ctags のファイルを現在の階層から下に続けて検索する
if has('path_extra')
  set tags+=./**4/tags;
  set tags+=tags;
endif
