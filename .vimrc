" =============================================================================
" File:          .vimrc
" Description:   vim global configuration
" Maintainer:    Adrien Lemaire <lemaire.adrien@gmail.com>
" Version:       2.0
" Last Modified: Fri Jan 28, 2011  02:33PM
" License:       This program is free software. It comes without any warranty,
"                to the extent permitted by applicable law. You can redistribute
"                it and/or modify it under the terms of the Do What The Fuck You
"                Want To Public License, Version 2, as published by Sam Hocevar.
"                See http://sam.zoy.org/wtfpl/COPYING for more details.
" Documentation: See README
"==============================================================================

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
    filetype on
    filetype plugin indent on
    autocmd BufRead *.txt set tw=78
    au BufRead,BufNewFile *.txt set filetype=doctest " coloration with doctest.vim
else
    set autoindent " always set autoindenting on
endif

if has("mouse")
    set mouse=a " mouse enabled in vim
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

" Visible markers
highlight SignColumn ctermbg=darkgrey
sign define information text=!> linehl=Warning texthl=Error
map <F2> :exe ":sign place 08111987 line=" . line(".") ." name=information file=" . expand("%:p")<CR>
"map <C-F2> :sign unplace<CR> TODO broken

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

" List classes and methods in the opened files
map <F8> :TlistToggle<cr>
let Tlist_GainFocus_On_ToggleOpen=0
let Tlist_Exit_OnlyWindow=1

" better statusline
" left side
set statusline=%#User1#%F\ %#User2#%m%r%h%w\ %<%{&ff}%-15.y
set statusline+=\ [ascii:\%03.3b/hexa:\%02.2B]
" right side
set statusline+=\ %=\ %0.((%l,%v%))%5.p%%/%L
set statusline+=\ %=\ %{SetTimeOfDayColors()}\ %0.((%l,%v%))%5.p%%/%L
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




" Section: Functions
" ==================

" Function: LastModified
" If buffer modified, update any 'Last modified: ' in the first 20 lines.
" 'Last modified: ' can have up to 10 characters before (they are retained).
" Restores cursor and window position using save_cursor variable.
function! LastModified()
  if &modified
    let save_cursor = getpos(".")
    let n = min([20, line("$")])
    exe '1,' . n . 's#^\(.\{,10}Last Modified: \).*#\1' .
          \ strftime('%a %b %d, %Y  %I:%M%p') . '#e'
    call setpos('.', save_cursor)
  endif
endfun
autocmd BufWritePre * call LastModified()

" Function: SetTimeOfDayColors
" Function to change the colorscheme depending on the hour of the day
let g:colors_name="xyzzy"
let g:Favcolorschemes = ["darkblue", "Molokai", "candycode", "adrian"]
function SetTimeOfDayColors()
    " currentHour will be 0, 1, 2, or 3
    let g:CurrentHour = (strftime("%H") + 0) / 6
    if g:colors_name !~ g:Favcolorschemes[g:CurrentHour]
        execute "colorscheme " . g:Favcolorschemes[g:CurrentHour] 
        redraw
    endif
endfunction
call SetTimeOfDayColors()

" Function: FoldSpellBalloon
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


" Section: Python
" ===============
source ~/.vim/vimrc/vimrc_python.vim


" Section: LaTeX
" ==============
source ~/.vim/vimrc/vimrc_latex.vim
