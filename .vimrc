"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimrc example for Python developer
" Author: Adrien Lemaire <lemaire.adrien@gmail.com>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" -> Verify that vim has been compiled with +python
"
"
" Required plugins and libraries:
"   indent => http://www.vim.org/scripts/script.php?script_id=974
"   Syntax Color => http://www.vim.org/scripts/script.php?script_id=790
"   taglist => http://vim.sourceforge.net/scripts/script.php?script_id=273
"   pep8 => https://github.com/cburroughs/pep8.py
"   pydiction => http://www.vim.org/scripts/script.php?script_id=850
"       Place the complete-dict and pydiction.py files into ~/.vim/dicts
"   pyflakes => http://www.vim.org/scripts/script.php?script_id=2441
"   nose => pip install nose
"   vim-nosecompiler => https://github.com/olethanh/vim-nosecompiler
"   vim-makegreen => https://github.com/reinh/vim-makegreen
"       To fix a bug (when you run the tests with \t, it opens a nose file),
"       edit makegreen.vim line 26 and add a ! to the make command like so :
"          silent! make! %
"   doctest => http://www.vim.org/scripts/script.php?script_id=1867
"
"
" Maps :
"   F1 => help system for the word under the cursor
"   F2 => Place a sign in your code (ctrl-F2 to remove it)
"   F3 =>
"   F4 => Execute python script
"   F5 =>
"   F6 => CleanText (+ Pep8 if python)
"   F7 =>
"   F8 => Tag List
"   F9 =>
"   F10 =>
"   F11 =>
"   F12 =>
"
"
" Other plugins you could be interested by :
"   NERDCommenter => http://www.vim.org/scripts/script.php?script_id=1218
"   Pydoc => http://www.vim.org/scripts/script.php?script_id=910
"       \pw to see definition for word under the cursor
"   AutoComplPop => http://www.vim.org/scripts/script.php?script_id=1879
"   Bicycle Repair Man => http://bicyclerepair.sourceforge.net/
"   SnipMate => http://www.vim.org/scripts/script.php?script_id=2540
"   python_match => http://www.vim.org/scripts/script.php?script_id=386
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
"colorscheme xoria256
set t_Co=256            " get 256 colors in term


" Function to change the colorscheme depending on the hour of the day
"let g:colors_name="xyzzy"
let g:Favcolorschemes = ["darkblue", "default", "shine", "evening"]
function SetTimeOfDayColors()
    " currentHour will be 0, 1, 2, or 3
    let g:CurrentHour = (strftime("%H") + 0) / 6
    if g:colors_name !~ g:Favcolorschemes[g:CurrentHour]
        execute "colorscheme " . g:Favcolorschemes[g:CurrentHour] 
        redraw
    endif
endfunction
"call SetTimeOfDayColors()

" Tooltips
function! FoldSpellBalloon()
    let foldStart = foldclosed(v:beval_lnum )
    let foldEnd  = foldclosedend(v:beval_lnum)
    let lines = [] " Detect if we are in a fold
    if foldStart < 0
        " Detect if we are on a misspelled word
        let lines = spellsuggest( spellbadword(v:beval_text)[ 0 ], 5, 0 )
    else
        " we are in a fold
        let numLines = foldEnd - foldStart + 1
        " if we have too many lines in fold, show only the first 14
        " and the last 14 lines
        if ( numLines > 31 )
            let lines = getline( foldStart, foldStart + 14 )
            let lines += [ '-- Snipped ' . ( numLines - 30 ) . ' lines --' ]
            let lines += getline( foldEnd - 14, foldEnd )
        else "less than 30 lines, lets show all of them
            let lines = getline( foldStart, foldEnd )
        endif
    endif
    " return result
    return join( lines, has( "balloon_multiline" ) ? "\n" : " " )
endfunction
set balloonexpr=FoldSpellBalloon()
set ballooneval


if v:version >= 703
    set colorcolumn=80      " Coloration of the 80th column
    set cursorcolumn
    set cursorline
endif


if &t_Co> 2 || has("gui_running")
    " When terminal has colors, active syntax coloration
    syntax on
    set hlsearch " Highlight results
    " TIP: Type 'nohl' to remove highlight
    set incsearch " Highlight of the first matching string
    set smartcase " Highlight first matching string using history
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
    au BufRead,BufNewFile *.txt set filetype=doctest " coloration with doctest.vim
    set omnifunc=pythoncomplete#Complete " Python autocompletion !
    let g:pydiction_location = "~/.vim/dicts/"
    let g:pydiction_menu_height = 20
else
    set autoindent " always set autoindenting on
endif


if has("mouse")
    set mouse=a " mouse enabled in vim
endif


" Show hidden characters like tab or endl
set list
set lcs:tab:>-,trail:.


" highlight trailing spaces
"highlight RedundantSpaces ctermbg=red guibg=red  USELESS
"match RedundantSpaces /\s\+$\| \+\ze\t\|\t/


set backup " Keep a backup file
if !filewritable($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p") " Creation of the backup dir
endif
set backupdir=$HOME/.vim/backup " directory for ~ files
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
    " add spaces to {% var %} and {{ var  }} in the templates if missing
    " silent will hide the press-Enter
    " ge will hide the Not Found errors raised
    silent :%s/[^ ]\zs\ze[ %}]}/ /ge
    silent :%s/{[%{]\zs\ze[^ ]/ /ge
    "exe ':%s/[^ ]\zs\ze[ %}]}/ /g'
    "exe ':%s/{[%{]\zs\ze[^ ]/ /g'
    set nolazyredraw
    call cursor(curline, curcol)
    if &filetype == 'python'
        " if the current file is in python, we launch pep8
        call <SID>Pep8()
    endif
endfun

map <F6> :call CleanText()<CR>
" ------- end Cleaning stuff ---------


fun ExecPython()
    " Try to execute the script in python 2.6, else python 3.1
    try
        pyf @%
    catch
        silent !python3.1 %
        " PS: if you launch a graphical interface such as a pygame script, your
        " vim window may be all black. In this case, redraw the vim window with
        " ^L
    endtry
endfun
" Execute the python script from vim
map <silent> <F4> :call ExecPython()<CR>


" Python syntax test from syntax/python.vim plugin
let python_highlight_all = 1


" Ignore some files with tab autocompletion
set suffixes=*~,*.pyc,*.pyo


" Red background to highlight searched patterns
hi Search  term=reverse ctermbg=Red ctermfg=White guibg=Red guifg=White


" better statusline
" left side
set statusline=%#User1#%F\ %#User2#%m%r%h%w\ %<%{&ff}%-15.y
set statusline+=\ [ascii:\%03.3b/hexa:\%02.2B]
" right side
set statusline+=\ %=\ %0.((%l,%v%))%5.p%%/%L
"set statusline+=\ %=\ %{SetTimeOfDayColors()}\ %0.((%l,%v%))%5.p%%/%L
set laststatus=2
if version >= 700
    " Filename
    highlight User1 cterm=bold ctermfg=4 ctermbg=Black
    highlight User2 term=bold,underline cterm=bold,underline gui=bold,underline
    " Search
    highlight Search term=standout ctermfg=4 ctermbg=7
    " SplitLine
    highlight VertSplit ctermbg=red ctermfg=Black guibg=red
    au VimEnter * hi StatusLine term=bold ctermfg=DarkRed ctermbg=7 gui=bold
    " statusline color change when in insert mode
    au InsertEnter * hi StatusLine term=underline ctermbg=3 gui=underline
    au InsertLeave * hi StatusLine term=bold ctermfg=DarkRed ctermbg=7 gui=bold
    " Cursor
    highlight CursorLine ctermbg=233 cterm=bold
    highlight CursorColumn ctermbg=233 cterm=bold
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

" Use F1 to find the help for the word under the cursor
map <F1> <ESC>:exec "help ".expand("<cWORD>")<CR>


" Visible markers
highlight SignColumn ctermbg=darkgrey
sign define information text=!> linehl=Warning texthl=Error
map <F2> :exe ":sign place 08111987 line=" . line(".") ." name=information file=" . expand("%:p")<CR>
"map <C-F2> :sign unplace<CR> TODO broken


