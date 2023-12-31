" Open file with `go`
" Try bib folder for match

nmap go :call OpenFile()<CR>

fu! OpenFile()
  if filereadable($HOME."/Documents/Bib/".expand("<cfile>").".pdf")
     :!open ~/Documents/Bib/<cfile>.pdf
  else
     :!open <cfile>
  endif
endfu

