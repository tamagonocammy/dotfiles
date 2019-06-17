" Basic Vundle configuration
set nocompatible   " Disable VI compatibility mode
syntax on
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
let g:dracula_colorterm = 0
colorscheme dracula
let g:airline_powerline_fonts = 1
set guifont=Droid\ Sans\ Mono\ Nerd\ Font\ 11
autocmd! BufWritePost ~/.vimrc nested :source ~/.vimrc
" Bundles
Plugin 'gmarik/vundle'
Plugin 'vim-ruby/vim-ruby'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'othree/html5.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'dracula/vim'
Plugin 'bufexplorer.zip'
Plugin 'pangloss/vim-javascript'
Plugin 'KabbAmine/vCoolor.vim'	
Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'plasticboy/vim-markdown'
Plugin 'sukima/xmledit'
Plugin 'kovetskiy/sxhkd-vim'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-surround'
Plugin 'sheerun/vim-polyglot'
Plugin 'junegunn/goyo.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'PotatoesMaster/i3-vim-syntax'
Plugin 'airblade/vim-gitgutter'
Plugin 'mhinz/vim-startify'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'maxbrunsfeld/vim-yankstack'
Plugin 'metakirby5/codi.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'ryanoasis/vim-devicons'

" Tab behavior
set expandtab
let g:airline#extensions#tabline#enabled =1
set shiftwidth=2
set softtabstop=2
set tabstop=4

" General behavior
set nowrap                       " Not wrapping lines
set autowrite                    " Auto-save files before executing make
set hidden                       " Allow unsaved buffers
set backspace=indent,eol,start   " Backspace also via line breaks
set laststatus=2                 " Always display status bar
set noshowmode                   " Hide the default mode text
set encoding=utf-8               " Always use UTF-8 as encoding
set number                       " Show line numbers
let mapleader=","                " Comma instead of backslash as <leader>
hi Normal guibg=NONE ctermbg=NONE
let g:airline_theme='dracula'
nnoremap <silent> <leader>z :Goyo<cr>
nnoremap <Leader>ga :Git add %:p<CR><CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gp :Git push<CR>
" Shortcut for turning line wrapping on/off and convenient navigation when lines are wrapped
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

" NERDTree behavior
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif   " Close vim if the only window left open is a NERDTree
map <leader>n :NERDTreeToggle<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeQuitOnOpen = 1

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }


" CtrlP behavior
let g:ctrlp_working_path_mode=0   " Start searching from the currend working directory

" Windows behavior
if has("win32")
  set ffs=dos   " On Windows assume Cr-Lf line endings
  set directory=$TMP
else
  set directory=/tmp 
endif

" Vim-airline behavior
let g:airline#extensions#whitespace#enabled=0   " Disable whitespace checks

" File type specific behavior
autocmd FileType mkd setlocal shiftwidth=4 softtabstop=4

" Vundle wrap-up
filetype plugin indent on
" Make Y behavior consistent with C and D
map Y y$

" Map escape key to jj -- much faster to exit insert mode
imap jj <esc>

" Move cursor as usual through wrapped lines
nnoremap j gj
nnoremap k gk


" commonly capitalized commands
cnoremap W w
cnoremap Wq wq
cnoremap Q q



" move through quickfix and loclist
nnoremap ]q :cnext<CR>zz
nnoremap [q :cprev<CR>zz
nnoremap ]l :lnext<CR>zz
nnoremap [l :lprev<CR>zz

" move through buffers
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>

" move through tabs
      map <C-t> <Esc>:tabnew<CR>
      map <C-F4> <Esc>:tabclose<CR>
      map <C-Tab> <Esc>:tabnext<CR>
      map <C-S-Tab> <Esc>:tabprev<CR>
 nnoremap <leader>evm <C-w><C-v><C-l>:e $MYVIMRC<CR>

map <C-S> :w<CR>

