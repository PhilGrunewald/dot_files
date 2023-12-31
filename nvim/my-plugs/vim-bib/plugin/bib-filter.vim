" for BibPy
function BibFilter(pattern,fields)
    PWD
    write
    let cmd = "!python -c \"import bib; bib.filter('".a:pattern."',".a:fields.",'".expand('%:p')."')\""
    echo cmd
    execute cmd
    let cmd = "e .".expand('%')
    execute cmd
endfunction

fu NewDOI(...)
  if a:0
    let doi = a:1
  else
    let doi = expand("<cword>")
  endif
  echo doi
  exe "r !doi2bib ".doi
endfu
