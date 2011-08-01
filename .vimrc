" load pathogen
source ~/.vim/bundle/pathogen/autoload/pathogen.vim
filetype off
call pathogen#runtime_append_all_bundles()
" call pathogen#infect()
call pathogen#helptags()


""""""""""""""""""""
" General settings "
""""""""""""""""""""

set nocompatible        " Use vim defaults
set termencoding=utf-8  " character encoding
set enc=utf-8
set fenc=utf-8
set bs=2                " Authorize all deletion
set ai                  " Always auto-indent
set viminfo='20,\"50    " Read/write a .viminfo file, 50 lines max
set history=200         " Save the last 200 commands in history
set undolevels=100      " Save the last 200 undos in history
set ruler               " Always show the cursor
set shiftwidth=4        " Number of characters per indentation
set tabstop=4           " Number of spaces per tabulation
set softtabstop=4       " Number of spaces per backspace
set expandtab           " Convert tabs into spaces
set tw=80               " 80 characters max per line
set nu                  " Display the number of each line
set showcmd             " Display incomplete commands
set ttyfast             " Fast terminal connection 
set title               " Name of the file in the window tab's title
set noerrorbells        " Shut the bell
"set spell               " Enable spellchecking
"set spelllang=en,fr     " spellchecking english and french
"set spellsuggest=10     " 10 alternative spelling maximum
set isfname+=32         " gf support filenames with spaces
set t_Co=256            " get 256 colors in term
colorscheme asu1dark     " set colorscheme
if v:version >= 703
    set colorcolumn=80      " Coloration of the 80th column
    "set cursorcolumn
    "set cursorline
endif

" Show hidden characters like tab or endl
set list
set lcs:tab:>-,trail:.

set backup " Keep a backup file
if !filewritable($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p") " Creation of the backup dir
endif
set backupdir=$HOME/.vim/backup " directory for ~ files
set directory=.,./.backup,/tmp

let mapleader = ","

let g:snips_author = "Adrien Lemaire"

" .vimrc autoreload
autocmd BufWritePost .vimrc source %

" Deactivate keyboard arrows
noremap  <Up> ""
noremap! <Up> <Esc>
noremap  <Down> ""
noremap! <Down> <Esc>
noremap  <Left> ""
noremap! <Left> <Esc>
noremap  <Right> ""
noremap! <Right> <Esc>

set wildmenu " Enable menu at the bottom of the vim window
set wildmode=list:longest,full



"""""""""""""""""""""""""""""""
" BASIC EDITING AND DEBUGGING "
"""""""""""""""""""""""""""""""

" type 'za' to open and close a fold.
set foldmethod=indent
set foldlevel=99

" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Override some mappings which are in conflict
if !hasmapto('<Plug>TaskList')
    map <unique> <Leader>T <Plug>TaskList
endif
if !hasmapto('MakeGreen')
  map <unique> <silent> <Leader>M :call MakeGreen()<cr>
endif


" Map the task list to find TODO and FIXME
map <leader>td <Plug>TaskList

" View diff's of every save on a file we've made, quickly revert back and forth
map <leader>g :GundoToggle<CR>


""""""""""""""""""""""""""""""""""""""
" SYNTAX HIGHLIGHTING AND VALIDATION "
""""""""""""""""""""""""""""""""""""""

syntax on                           " syntax highlighing
filetype on                          " try to detect filetypes
filetype plugin indent on    " enable loading indent file for filetype

" Don't let pyflakes use the quickfix window
let g:pyflakes_use_quickfix = 0

" map pep8
let g:pep8_map='<leader>8'

" coloration with doctest.vim
au BufRead,BufNewFile *.txt set filetype=doctest


""""""""""""""""""""""""""""""""""""
" TAB COMPLETION AND DOCUMENTATION "
""""""""""""""""""""""""""""""""""""

" make SuperTab context sensitive and enable omni code completion
autocmd BufRead *.py set tw=79 " 79 characters max on python files
au FileType python set omnifunc=pythoncomplete#Complete
autocmd BufNewFile,BufRead *.py compiler nose
let g:pydiction_location = "~/.vim/dicts/"
let g:pydiction_menu_height = 20
let g:SuperTabDefaultCompletionType = "context"

" Enable the menu and pydoc preview to get the most useful info out of the
" code completion. <leader>pwd open a new window with the whole doc page.
set completeopt=menuone,longest,preview

" Use F1 to find the help for the word under the cursor
map <F1> <ESC>:exec "help ".expand("<cWORD>")<CR>


"""""""""""""""""""
" CODE NAVIGATION "
"""""""""""""""""""

" With minibufexpl plugin, type :buffers to get the list of buffers
" Switch buffer: b<number> or :b filenam<tab> with file name autocompletion
" close a buffer:  :bd or :bw

" command-t settings. by default bound to <leader>t, needs a "rake make" !
"  supports searching only through opened buffers, instead of files
" using <leader>b.

map <leader>n :NERDTreeToggle<CR>

" Ropevim settings
map <leader>j :RopeGotoDefinition<CR>
map <leader>r :RopeRename<CR>

" Binding for fuzzy text search via ack (similar to grep)
nmap <leader>a <Esc>:Ack!

" List classes and methods in the opened files
map <F8> :TlistToggle<cr>
let Tlist_GainFocus_On_ToggleOpen=0
let Tlist_Exit_OnlyWindow=1

""""""""""""""""""""""""
" INTEGRATION WITH GIT "
""""""""""""""""""""""""

" Git.vim provides syntax highlighting for git config files
" fugitive.vim provides an interface for interacting with git including
" getting diffs, status updates, commiting, and moving files

" Show what branch we are working on
" better statusline
" left side
set statusline=%#User1#%F\ %#User2#%m%r%h%w\ %<%{&ff}%-15.y
set statusline+=\ [ascii:\%03.3b/hexa:\%02.2B]
" right side
set statusline+=\ %=%{fugitive#statusline()}\ %0.((%l,%v%))%5.p%%/%L
" set statusline+=\ %=\ %{SetTimeOfDayColors()}\ %0.((%l,%v%))%5.p%%/%L
set laststatus=2

" Commands to know: Gblame, Gwrite, Gread, Gcommit


""""""""""""""""""""
" TEST INTEGRATION "
""""""""""""""""""""

" Mapping for Makegreen
map <leader>dt :set makeprg=python\ manage.py\ test\|:call MakeGreen()<CR>

" Execute the tests
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>
" cycle through test errors
nmap <silent><Leader>tn <Esc>:Pytest next<CR>
nmap <silent><Leader>tp <Esc>:Pytest previous<CR>
nmap <silent><Leader>te <Esc>:Pytest error<CR>


"""""""""""""""
" VIRTUALENV  "
"""""""""""""""

" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF


"""""""""""
" DJANGO  "
"""""""""""

" Get code completion for django modules by importing DJANGO_SETTINGS_MODULE
" add : export DJANGO_SETTINGS_MODULE=project.settings   to .zshrc
