" .bib is a latex extension for writing bibliography


" a 2-spaces indentation looks good with latex
setlocal sw=2
setlocal tabstop=2
setlocal softtabstop=2

" the biblatex package introduce a new bib tag: online
let s:key='<+key+>'
let s:{'online'}_required=""
let s:{'online'}_optional1="ath"
let s:{'online'}_optional2="myz"
let s:{'online'}_retval = '@MISC{' . s:key . ','."\n"

let g:Bib_online_options = "atmy"
let g:Bib_online_extrafields = "url"
