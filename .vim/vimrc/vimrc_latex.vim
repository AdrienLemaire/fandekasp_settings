" =============================================================================
" File:          vimrc_latex.vim
" Description:   vim global configuration
" Maintainer:    Adrien Lemaire <lemaire.adrien@gmail.com>
" Version:       2.0
" Last Modified: Sat Jan 15, 2011  05:50PM
" License:       This program is free software. It comes without any warranty,
"                to the extent permitted by applicable law. You can redistribute
"                it and/or modify it under the terms of the Do What The Fuck You
"                Want To Public License, Version 2, as published by Sam Hocevar.
"                See http://sam.zoy.org/wtfpl/COPYING for more details.
"==============================================================================

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:
