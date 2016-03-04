set number
syntax on

hi CursorLineNR cterm=bold
augroup CLNRSet
    autocmd! ColorScheme * hi CursorLineNR cterm=bold
augroup END

call plug#begin('~/.vim/plugged')
Plug 'bling/vim-airline'
Plug 'junegunn/goyo.vim'

set tabstop=2
set shiftwidth=2
set noexpandtab
