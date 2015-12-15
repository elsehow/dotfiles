autocmd BufRead,BufNewFile *.cljs setlocal filetype=clojure
let g:rainbow_active = 1
set number
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" set markdown syntax
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

noremap <C-tab> :tabn<CR>

call plug#begin('~/.vim/plugged')
Plug 'junegunn/goyo.vim'
Plug 'luochen1990/rainbow'
"Plug 'tpope/vim-fireplace'
"Plug 'mxw/vim-jsx'
"Plug 'isRuslan/vim-es6'
call plug#end()

