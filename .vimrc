
"
"       ________ ++     ________
"      /VVVVVVVV\++++  /VVVVVVVV\
"      \VVVVVVVV/++++++\VVVVVVVV/
"       |VVVVVV|++++++++/VVVVV/'
"       |VVVVVV|++++++/VVVVV/'
"      +|VVVVVV|++++/VVVVV/'+
"    +++|VVVVVV|++/VVVVV/'+++++
"  +++++|VVVVVV|/VVVVV/'+++++++++
"    +++|VVVVVVVVVVV/'+++++++++
"      +|VVVVVVVVV/'+++++++++
"       |VVVVVVV/'+++++++++
"       |VVVVV/'+++++++++
"       |VVV/'+++++++++
"       'V/'   ++++++
"                ++
"
" My Vim's Configuration by Camila Valencia~
set nocompatible   " Disable VI compatibility mode
syntax on
colorscheme gruvbox
set t_Co=256
let g:gruvbox_termcolors=16
set background=dark
filetype plugin indent on
call plug#begin('~/.vim/plugged')
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
set mouse=a
set guifont=UbuntuMono\ Nerd\ Font\ Mono\ 11
set guioptions-=T
set guioptions-=l"remove toolbar and scrollbars
set guioptions-=r
set guioptions-=R
" Bundles
Plug 'vim-ruby/vim-ruby'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'othree/html5.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'jlanzarotta/bufexplorer'
Plug 'pangloss/vim-javascript'
Plug 'KabbAmine/vCoolor.vim'	
Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
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
Plug 'majutsushi/tagbar'
Plug 'motemen/git-vim'
Plug 'Townk/vim-autoclose'
Plug 'davidhalter/jedi-vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'lilydjwg/colorizer'
if has('python')
    " YAPF formatter for Python
    Plug 'pignacio/vim-yapf-format'
endif
Plug 'junegunn/fzf.vim'
Plug '~/.fzf'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mileszs/ack.vim'

call plug#end()
" Tab behavior
set expandtab
let g:airline#extensions#tabline#enabled =1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" enable/disable fugitive/lawrencium integration
let g:airline#extensions#branch#enabled = 1

" enable/disable showing a summary of changed hunks under source control.
let g:airline#extensions#hunks#enabled = 1

" enable/disable showing only non-zero hunks.
let g:airline#extensions#hunks#non_zero_only = 1

let g:airline#extensions#whitespace#enabled = 0
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
let g:airline_theme='gruvbox'
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
nnoremap <Leader>ga :Git add %:p<CR><CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gp :Git push<CR>
let g:AutoClosePreserveDotReg = 0
" Fast saving
nmap <leader>w :w!<cr>
" Highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch
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

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" CtrlP behavior
let g:ctrlp_working_path_mode=0   " Start searching from the currend working directory

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use the the_silver_searcher if possible (much faster than Ack)
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
map <leader>g :Ack

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

" Make sure that enter is never overriden in the quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

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

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>


" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" move through tabs
      map <C-t> <Esc>:tabnew<CR>
      map <C-F4> <Esc>:tabclose<CR>
      map <C-Tab> <Esc>:tabnext<CR>
      map <C-S-Tab> <Esc>:tabprev<CR>
 nnoremap <leader>evm <C-w><C-v><C-l>:e $MYVIMRC<CR>


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
if has('gui_running')
  colorscheme gruvbox
endif

" Jedi-vim ------------------------------

" All these mappings work only for python code:
" Go to definition
let g:jedi#goto_command = ',d'
" Find ocurrences
let g:jedi#usages_command = ',o'
" Find assignments
let g:jedi#goto_assignments_command = ',a'
" Go to definition in new tab
nmap ,D :tab split<CR>:call jedi#goto()<CR>

autocmd VimEnter * hi Normal ctermbg=none

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'

" Source the vimrc file after saving it
if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
  endif
  """"""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python map <buffer> F :set foldmethod=indent<cr>

au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f # --- <esc>a
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def
au FileType python set cindent
au FileType python set cinkeys-=0#
au FileType python set indentkeys-=0#


""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript imap <c-t> $log();<esc>hi
au FileType javascript imap <c-a> alert();<esc>hi

au FileType javascript inoremap <buffer> $r return
au FileType javascript inoremap <buffer> $f // --- PH<esc>FP2xi

function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction


""""""""""""""""""""""""""""""
" => CoffeeScript section
"""""""""""""""""""""""""""""""
function! CoffeeScriptFold()
    setl foldmethod=indent
    setl foldlevelstart=1
endfunction
au FileType coffee call CoffeeScriptFold()

au FileType gitcommit call setpos('.', [0, 1, 1, 0])


""""""""""""""""""""""""""""""
" => Shell section
""""""""""""""""""""""""""""""
if exists('$TMUX')
    if has('nvim')
        set termguicolors
    else
        set term=screen-256color
    endif
endif


""""""""""""""""""""""""""""""
" => Twig section
""""""""""""""""""""""""""""""
autocmd BufRead *.twig set syntax=html filetype=html


""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>


" NERDTree behavior
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif   " Close vim if the only window left open is a NERDTree
map <leader>n :NERDTreeToggle<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeShowHidden=0
let g:NERDTreeWinSize=35
map <leader>nf :NERDTreeFind<cr>
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimroom
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic (syntax checker)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'javascript': ['jshint'],
\   'python': ['flake8'],
\   'go': ['go', 'golint', 'errcheck']
\}

nmap <silent> <leader>a <Plug>(ale_next_wrap)

" Disabling highlighting
let g:ale_set_highlights = 0

" Only run linting when saving the file
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Git gutter (Git diff)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=0
nnoremap <silent> <leader>d :GitGutterToggle<cr>
