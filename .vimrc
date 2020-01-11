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
" My Neovim's Configuration by Camila Valencia~
" General stuff {{{
set nocompatible   " Disable VI compatibility mode
syntax on
colorscheme dracula 
set t_Co=256
set background=dark
filetype plugin indent on
call plug#begin('~/.config/nvim/plugged')
let g:airline_powerline_fonts = 1
set mouse=a
set guifont=FuraMono\ Nerd\ Font\ Mono\ 9
set guioptions=m
nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
set foldmethod=marker
set nowrap                       " Not wrapping lines
set autowrite                    " Auto-save files before executing make
set hidden                       " Allow unsaved buffers
set backspace=indent,eol,start   " Backspace also via line breaks
set laststatus=2                 " Always display status bar
set noshowmode                   " Hide the default mode text
set encoding=utf-8               " Always use UTF-8 as encoding
set number                       " Show line numbers
let mapleader=","                " Comma instead of backslash as <leader>
set nobackup
set nowritebackup
" Better display for messages
set cmdheight=2
let g:airline_theme='dracula'
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
"}}}
" Bundles{{{
Plug 'vim-ruby/vim-ruby'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'othree/html5.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'jlanzarotta/bufexplorer'
Plug 'pangloss/vim-javascript'	
Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'garbas/vim-snipmate'
Plug 'arcticicestudio/nord-vim'
Plug 'honza/vim-snippets'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline-themes'
Plug 'plasticboy/vim-markdown'
Plug 'sukima/xmledit'
Plug 'kovetskiy/sxhkd-vim'
Plug 'lambdalisue/suda.vim'
Plug 'tpope/vim-surround'
Plug 'chrisbra/Colorizer'
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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
Plug 'liuchengxui/vista.vim'
if has('python')
    " YAPF formatter for Python
    Plug 'pignacio/vim-yapf-format'
endif
Plug 'junegunn/fzf.vim'
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'edkolev/tmuxline.vim'
Plug 'edkolev/promptline.vim'
call plug#end()
"}}}
" Tab behavior{{{
set expandtab
let g:airline#extensions#tabline#enabled =1
let g:airline_skip_empty_sections = 1
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
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'
nmap <c-f> :Ag<CR>
"}}}
" Keybindings{{{
nnoremap <silent> <leader>z :Goyo<cr>
nnoremap <Leader>ga :Git add %:p<CR><CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gp :Git push<CR>
let g:AutoClosePreserveDotReg = 0
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
 map <M-Tab> <Esc>:tabnext<CR>
 map <M-S-Tab> <Esc>:tabprev<CR>
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
"}}}
" Plugin settings{{{
" " NERDTree behavior
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif   " Close vim if the only window left open is a NERDTree
map <leader>n :NERDTreeToggle<CR>
nmap <Leader>nf :NERDTreeFind<CR>
let NERDTreeCascadeSingleChildDir=0
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeShowHidden=1
nmap <leader>rn :NERDTree<cr> \| R \| <c-w><c-p>
let nerdchristmastree=1
let g:NERDTreeDirArrowExpandable = '▷'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeAutoCenter=1
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

" Tmuxline behavior
let g:tmuxline_preset = { 
      \'a'    : '#(whoami)',
      \'b'    : '#H',
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W'],
      \'x'    : ['#(~/scripts/tmux-nowplayer)'],
      \'y'    : '#(date +"%I:%M %p")',
      \'z'    : '#S'}

let g:airline#extensions#tmuxline#enabled = 1
let airline#extensions#tmuxline#snapshot_file = "~/.tmux-status.conf"
" promptline behavior "
let g:promptline_preset = {
        \'a' : [ promptline#slices#host() ],
        \'b' : [ promptline#slices#user() ],
        \'c' : [ promptline#slices#cwd() ],
        \'y' : [ promptline#slices#vcs_branch() ],
        \'warn' : [ promptline#slices#last_exit_code() ]}
let g:promptline_theme = 'airline'
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

  " ---> youcompleteme configuration <---
  let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
  
  " ---> compatibility with another plugin (ultisnips) <---
  let g:ycm_key_list_select_completion = [ '<C-n>', '<Down>' ] 
  let g:ycm_key_list_previous_completion = [ '<C-p>', '<Up>' ]
  let g:SuperTabDefaultCompletionType = '<C-n>'
" ---> disable preview window <---
  set completeopt-=preview
" ---> navigating to the definition of a a symbol <---
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"""""""""""""""
" Git Gutter  "
"""""""""""""""
let g:gitgutter_enabled = 1
let g:gitgutter_grep=''
""""""""""""""
"Devicons   "
"""""""""""""
let g:webdevicons_enable = 1
let g:webdevicons_enable_unite = 1
let g:webdevicons_enable_denite = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_vimfiler = 1
let g:WebDevIconsUnicodeDecorateFileNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
let g:webdevicons_enable_airline_statusline = 1
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ''
let g:DevIconsDefaultFolderOpenSymbol = ''
""""""""""""""
" coc.nvim "
""""""""""""""
" list extensions
 let g:coc_global_extensions = [
       \ 'coc-lists',
       \ 'coc-eslint',
       \ 'coc-snippets',
       \ 'coc-emmet',
       \ 'coc-yank', 
       \ 'coc-highlight',
       \ 'coc-tsserver',
       \ 'coc-python',
       \ 'coc-html',
       \ 'coc-json',
       \ 'coc-yaml',
       \ 'coc-markdownlint',
       \ 'coc-css',
       \]
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silen> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>t

"liuchengxu/vista.vim
let g:vista_default_executive = 'coc'
nmap <Leader>v :Vista!!<CR>
"}}}
