" Delete current file

command! Delete :call DeleteFile()

fu! DeleteFile()
  !mv % ~/.Trash/ 
  bd
endfu
