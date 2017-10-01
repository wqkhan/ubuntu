
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Essential Plugins

Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'tpope/vim-vinegar'
Plugin 'kien/ctrlp.vim'

set number
set relativenumber

set smartindent
set tabstop=4
set shiftwidth=5
set expandtab

" open a NERDTree automatically when vim starts up
" autocmd vimenter * NERDTree

" map a specific key or shortcut to open NERDTree
map <F2> :NERDTreeToggle<CR>

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required