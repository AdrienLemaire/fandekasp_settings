"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimrc example for Python developer
" Maintainer : Adrien Lemaire <lemaire.adrien@gmail.com>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" -> Verify that vim has been compiled with +python
" -> Create a backup directory in ~/.vimrc for ~ files
"
"
" Required plugins and libraries:
"   indent => http://www.vim.org/scripts/script.php?script_id=974
"   taglist => http://vim.sourceforge.net/scripts/script.php?script_id=273
"   pep8 => https://github.com/cburroughs/pep8.py
"   pyflakes => http://www.vim.org/scripts/script.php?script_id=2441
"   nose => pip install nose
"   vim-nosecompiler => https://github.com/olethanh/vim-nosecompiler
"   vim-makegreen => https://github.com/reinh/vim-makegreen
"       To fix a bug (when you run the tests with \t, it opens a nose file),
"       edit makegreen.vim line 26 and add a ! to the make command like so :
"          silent! make! %
"
"
" Maps :
"   F1 =>
"   F2 =>
"   F3 =>
"   F4 => Execute python script
"   F5 =>
"   F6 => CleanText (+ Pep8 if python)
"   F7 =>
"   F8 => Tag List
"   F9 =>
"   F10 =>
"   F11 => French spellchecking
"   F12 => English spellchecking
"
"
" Other plugins you could be interested by :
"   NERDCommenter => http://www.vim.org/scripts/script.php?script_id=1218
"   Pydoc => http://www.vim.org/scripts/script.php?script_id=910
"   AutoComplPop => http://www.vim.org/scripts/script.php?script_id=1879
"   Bicycle Repair Man => http://bicyclerepair.sourceforge.net/
"   SnipMate => http://www.vim.org/scripts/script.php?script_id=2540
"   Syntax Color => http://www.vim.org/scripts/script.php?script_id=790
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible        " Use vim defaults
set termencoding=utf-8  " character encoding
set enc=utf-8
set fenc=utf-8
set bs=2                " Authorize all deletion
set ai                  " Always auto-indent
set backup              " Keep a backup file
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
"colorscheme Mahewincs

if v:version >= 703
    set colorcolumn=80      " Coloration of the 80th column
endif

if &t_Co> 2 || has("gui_running")
    " When terminal has colors, active syntax coloration
    syntax on
    " Coloration of last searched pattern
    " Type 'nohl' to remove highlight
    set hlsearch
    set incsearch " highlight of matching string while searching a pattern.
endif


if has("autocmd")
    autocmd BufRead *.txt set tw=78
    autocmd BufRead *.py set tw=79 " 79 characters max on python files
    " ---- is it useful ? ----
    "augroup cprog
        "" Remove all cprog autocommands
        "au!
        "autocmd FileType * set formatoptions=tcql nocindent comments&
    " ------------------------
    filetype on
    filetype plugin indent on
    "autocmd FileType python compiler pylint
    autocmd BufNewFile,BufRead *.py compiler nose
    set omnifunc=pythoncomplete#Complete " Python autocompletion !
else
    set autoindent " always set autoindenting on
endif

set mouse=a " mouse enabled in vim

" Show hidden characters like tab or endl
set list
set lcs:tab:>-,trail:.

" highlight trailing spaces
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t\|\t/


" directory for ~ files
set backupdir=$HOME/.vim/backup
set directory=.,./.backup,/tmp


" ------- Cleaning stuff ---------
function <SID>Pep8()
  set lazyredraw
  " Close any existing cwindows.
  cclose
  let l:grepformat_save = &grepformat
  let l:grepprogram_save = &grepprg
  set grepformat&vim
  set grepformat&vim
  let &grepformat = '%f:%l:%m'
  let &grepprg = 'pep8 --repeat'
  if &readonly == 0 | update | endif
  silent! grep! %
  let &grepformat = l:grepformat_save
  let &grepprg = l:grepprogram_save
  let l:mod_total = 0
  let l:win_count = 1
  " Determine correct window height
  windo let l:win_count = l:win_count + 1
  if l:win_count <= 2 | let l:win_count = 4 | endif
  windo let l:mod_total = l:mod_total + winheight(0)/l:win_count |
        \ execute 'resize +'.l:mod_total
  " Open cwindow
  execute 'belowright copen '.l:mod_total
  nnoremap <buffer> <silent> c :cclose<CR>
  set nolazyredraw
  redraw!
endfunction

fun CleanText()
    " Remove trailing spaces
    let curcol = col(".")
    let curline = line(".")
    exe ":retab"
    exe ":%s/ \\+$//e"
    call cursor(curline, curcol)
    if &filetype == 'python'
        " if the current file is in python, we launch pep8
        call <SID>Pep8()
    endif
endfun

map <F6> :call CleanText()<CR>
" ------- end Cleaning stuff ---------


" Execute the python script from vim
map <silent> <F4> "<Esc>:w!<cr>:!python %<cr>"


" Python syntax test
let python_highlight_all = 1


" Ignore some files with tab autocompletion
set suffixes=*~,*.pyc,*.pyo


" Red background to highlight searched patterns
hi Search  term=reverse ctermbg=Red ctermfg=White guibg=Red guifg=White


" better statusline
set statusline=%F%m%r%h%w\|\ %<%{&ff}%-15.y\ [ascii:\%03.3b/hexa:\%02.2B]\ %=%0.((%l,%v%))%5.p%%/%L
set laststatus=2
if version >= 700
    " statusline color change when in insert mode
    au VimEnter * hi StatusLine term=bold ctermfg=Black ctermbg=2 gui=bold
    au InsertEnter * hi StatusLine term=underline ctermbg=5 gui=underline
    au InsertLeave * hi StatusLine term=bold ctermfg=Black ctermbg=2 gui=bold
endif

" List classes and methods in the opened files
map <F8> :TlistToggle<cr>
let Tlist_GainFocus_On_ToggleOpen=0
let Tlist_Exit_OnlyWindow=1


" Disable quickfix for pyflakes
let g:pyflakes_use_quickfix = 0


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


" spellchecking
map <silent> <F11> "<Esc>:silent setlocal spell! spelllang=fr<CR>"
map <silent> <F12> "<Esc>:silent setlocal spell! spelllang=en<CR>"
