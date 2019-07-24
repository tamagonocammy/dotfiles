colorscheme dracula
colors dracula
" Basic Vundle configuration
set nocompatible   " Disable VI compatibility mode
syntax on
filetype off
call plug#begin('~/.vim/plugged')
let g:airline_powerline_fonts = 1
set mouse=a
set guifont=SauceCodePro\ Nerd\ Font\ 11
set guioptions-=T  "remove toolbar
set termguicolors
" Bundles
Plug 'gmarik/vundle'
Plug 'vim-ruby/vim-ruby'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'othree/html5.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'dracula/vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'pangloss/vim-javascript'
Plug 'KabbAmine/vCoolor.vim'	
Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'plasticboy/vim-markdown'
Plug 'sukima/xmledit'
Plug 'kovetskiy/sxhkd-vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-fugitive'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-startify'
Plug 'terryma/vim-multiple-cursors'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'metakirby5/codi.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
call plug#end()

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
 

vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa


    " Remap Splits to not have to press ctrl-w first
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>


let g:startify_custom_header=[
    \ '                          ',
    \ '    ##############..... ##############     ',
    \ '      ##############......##############   ',
    \ '        ##########..........##########     ',
    \ '        ##########........##########       ',
    \ '        ##########.......##########        ',
    \ '        ##########.....##########..        ',
    \ '        ##########....##########.....      ',
    \ '      ..##########..##########.........    ',
    \ '    ....##########.#########.............  ',
    \ '      ..################JJJ............    ',
    \ '        ################.............      ',
    \ '        ##############.JJJ.JJJJJJJJJJ      ',
    \ '        ############...JJ...JJ..JJ  JJ     ',
    \ '        ##########....JJ...JJ..JJ  JJ      ',
    \ '        ########......JJJ..JJJ JJJ JJJ     ',
    \ '        ######    .........                ',
    \ '                .....                  ',
    \ '                                       ',
    \ ]
    let g:startify_lists = [
          \ { 'type': 'files',     'header': ['   Recent Files']            },
          \ { 'type': 'dir',       'header': ['   Recent Files in  '. getcwd()] },
\ ]
    let g:startify_files_number = 5

" fugitive git bindings
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>
nnoremap <leader>gt :Gcommit -v -q %:p<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <leader>gp :Ggrep<Space>
nnoremap <leader>gm :Gmove<Space>
nnoremap <leader>gb :Git branch<Space>
nnoremap <leader>go :Git checkout<Space>
nnoremap <leader>gps :Dispatch! git push<CR>
nnoremap <leader>gpl :Dispatch! git pull<CR>

" buffer management
nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>