call plug#begin('~/.vim/plugged')
Plug 'junegunn/goyo.vim'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-fireplace'
Plug 'mxw/vim-jsx'
Plug 'isRuslan/vim-es6'
call plug#end()

autocmd BufRead,BufNewFile *.cljs setlocal filetype=clojure
let g:rainbow_active = 1
set tabstop=2
set shiftwidth=2
set softtabstop=2
" always uses spaces instead of tab characters
set expandtab
