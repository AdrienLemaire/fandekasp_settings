"==============================================================================
" File:          vimrc_latex.vim
" Description:   vim global configuration
" Maintainer:    Adrien Lemaire <lemaire.adrien@gmail.com>
" Version:       2.0
" Last Modified: Wed Jun 15, 2011  02:53PM
" License:       This program is free software. It comes without any warranty,
"                to the extent permitted by applicable law. You can redistribute
"                it and/or modify it under the terms of the Do What The Fuck You
"                Want To Public License, Version 2, as published by Sam Hocevar.
"                See http://sam.zoy.org/wtfpl/COPYING for more details.
"==============================================================================
if &filetype == 'tex'
    " IMPORTANT: win32 users will need to have 'shellslash' set so that latex
    " can be called correctly.
    setlocal shellslash

    " IMPORTANT: grep will sometimes skip displaying the file name if you
    " search in a singe file. This will confuse Latex-Suite. Set your grep
    " program to always generate a file-name.
    setlocal grepprg=grep\ -nH\ $*

    " OPTIONAL: This enables automatic indentation as you type.
    filetype indent on

    " OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
    " 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
    " The following changes the default filetype back to 'tex':
    let g:tex_flavor='latex'

    " this is mostly a matter of taste. but LaTeX looks good with just a bit
    " of indentation.
    setlocal sw=2
    setlocal tabstop=2
    setlocal softtabstop=2

    " TIP: if you write your \label's as \label{fig:something}, then if you
    " type in \ref{fig: and press <C-n> you will automatically cycle through
    " all the figure labels. Very useful!
    setlocal iskeyword+=:

    let g:Tex_MultipleCompileFormats = 'pdf'
    "let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
    "let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'
    "let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'
    "let g:Tex_CompileRule_pdf = 'ps2pdf $*.ps'
    "let g:Tex_CompileRule_pdf = 'pdflatex --interaction=nonstopmode $*'
    let g:Tex_CompileRule_html = 'latex2html -split 0 -info 0 -no_navigation $*'
    let g:Tex_DefaultTargetFormat = "pdf"
    let g:Tex_ViewRuleComplete_pdf = 'mupdf $*.pdf'
    let g:Tex_ViewRuleComplete_html = 'xdg-open $*/index.html &'
    let g:Tex_ViewRule_pdf = 'mupdf'
    if has("unix") && match(system("uname"),'Darwin') != -1
        " It's a Mac!
        let g:Tex_ViewRule_pdf = 'open -a Preview.app'
    endif


    " prefill a dream.tex files with a template <= used by LucidDreamingBox program
    autocmd BufNewFile *dream.tex   0r ~/.vim/templates/dream.tex
endif
