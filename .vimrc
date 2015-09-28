call plug#begin('~/.vim/plugged')
Plug 'junegunn/goyo.vim'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-fireplace'
call plug#end()

autocmd BufRead,BufNewFile *.cljs setlocal filetype=clojure
let g:rainbow_active = 1
