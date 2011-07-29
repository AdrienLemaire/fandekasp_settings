" load pathogen
source ~/.vim/bundle/pathogen/autoload/pathogen.vim
filetype off
call pathogen#runtime_append_all_bundles()
" call pathogen#infect()
call pathogen#helptags()


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


""""""""""""""""""""""""""""""""""""
" TAB COMPLETION AND DOCUMENTATION "
""""""""""""""""""""""""""""""""""""

" make SuperTab context sensitive and enable omni code completion
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
" Enable the menu and pydoc preview to get the most useful info out of the
" code completion. <leader>pwd open a new window with the whole doc page.
set completeopt=menuone,longest,preview
