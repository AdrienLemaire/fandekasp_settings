" =============================================================================
" File:          vimrc_python.vim
" Description:   vim specific configuration for python
" Maintainer:    Adrien Lemaire <lemaire.adrien@gmail.com>
" Version:       2.0
" Last Modified: Sat Jan 15, 2011  05:47PM
" License:       This program is free software. It comes without any warranty,
"                to the extent permitted by applicable law. You can redistribute
"                it and/or modify it under the terms of the Do What The Fuck You
"                Want To Public License, Version 2, as published by Sam Hocevar.
"                See http://sam.zoy.org/wtfpl/COPYING for more details.
"==============================================================================

if has("autocmd")
    autocmd BufRead *.py set tw=79 " 79 characters max on python files
    "autocmd FileType python compiler pylint
    autocmd BufNewFile,BufRead *.py compiler nose
    set omnifunc=pythoncomplete#Complete " Python autocompletion !
    let g:pydiction_location = "~/.vim/dicts/"
    let g:pydiction_menu_height = 20
endif


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


" Function: CleanText
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


" Disable quickfix for pyflakes
let g:pyflakes_use_quickfix = 0
