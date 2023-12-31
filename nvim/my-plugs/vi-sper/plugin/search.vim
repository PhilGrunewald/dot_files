" For Spoliphil
function! SpSearchStr(line)
    if a:line == ''
        let line = getline(".")
        if strlen(line) > 100
            let line = line[:-23]
        endif
    else
        let line = a:line
    endif
    silent! bd! ~/Music/spotiphil/search.spot
    let cmd = "!python -c \"import spotiphil as sp; sp.search('".line."')\""
    silent execute cmd
    e! ~/Music/spotiphil/search.spot
endfunction
