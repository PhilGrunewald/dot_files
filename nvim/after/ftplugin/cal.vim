" load external changes
"
" TODO: 
" reload
" push>pull pairing
"
setlocal nonumber
setlocal norelativenumber
set foldcolumn=0

setlocal autoread
setlocal foldlevel=4
setlocal foldmethod=indent
setlocal shiftwidth=1
setlocal breakindent
setlocal breakindentopt=shift:6

imap <buffer> jj <Esc>:call Synchronise()<CR>

function! Synchronise()
    " indent timed events
    %s/^\zs\ze\d\d:\d\d /    /e
    " indent all day event
    %s/^\zs\ze\a/    /e
    Sync
endfunction

nnoremap <buffer> w :call NextWeek()<CR>
nnoremap <buffer> W :call LastWeek()<CR>
nnoremap <buffer> T :call Today()<CR>

function! Today()
    /__ w0
    let day = strftime("%d")
    if day[0] == 0
        " strip the leading 0
        let day = day[1]
    endif
    call search("^   " . day . " ")
    normal j
endfunction

function! NextWeek()
    /^   \d
    normal 6n
endfunction

function! LastWeek()
    /^   \d
    normal 9N
endfunction



function! MyFoldText()
    let itemsInDay  = v:foldend - v:foldstart + 1
    let itemsInWeek = v:foldend - v:foldstart - 12
    let itemsInMonth = v:foldend - v:foldstart - 66
    let itemsInYear = v:foldend - v:foldstart - 858
    if itemsInWeek < 1
        let itemsInWeek = 'No'
    endif
    if itemsInMonth < 1
        let itemsInMonth = 'No'
    endif

    if (v:foldlevel == 1)
        return ' ' . itemsInYear . ' events'
    elseif (v:foldlevel == 2)
        return ' ' . itemsInMonth . ' events'
    elseif (v:foldlevel == 3)
        return ' Week with ' . itemsInWeek . ' events'
    elseif (v:foldlevel == 4)
        return '    ' . itemsInDay . ' events'
    else 
        return 'fold'
    endif
endfunction

set foldtext=MyFoldText()

