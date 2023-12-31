" :Rename without an argument provides a promt
command! -nargs=* Rename call RenameFile(<f-args>)

function! RenameFile(...)
    " optional name - else prompt for name
    let old = expand('%')
    let ext = '.' . expand('%:e')
    if a:0
        let new = a:1
    else
        let new = input('New name ('.ext.'): ', expand('%:r'))
    endif
    exec ':silent !rm ' . old
    exec ':saveas ' . new . ext
    exec ':bd ' . old
    exec ':edit ' . new . ext
    redraw!
endfunction

