" Serve local file in browser
" the /Users/.../Sites/ part is replaced with http://localhost/
" specific to hypermarkdown which keeps markdown files in the _src folder and the corresponding (served) html files in site folder

command! Browse call Browse()

function! Browse()
  let filename = expand('%:p')
  let filename = substitute(filename,"\(.\{-}/\)\{4}", "http://localhost/", "")
  let filename = substitute(filename,".md", ".html", "")
  let filename = substitute(filename,"_src", "site", "")
  let cmd = "!open -a chrome " . filename
  execute cmd
  echo filename
endfunction
