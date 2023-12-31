if exists("g:comment_char")
  let g:comment_char = "#"
  execute commentOn
endif

function! SQLLine()
    " z: start on current line
    " b: backwards
    " W: no wrap
    let startLine = search(';','zbW') + 1
    let endLine = search(';','n')
    let query = getline(startLine,endLine)
    let qStr = ""
    for line in query
        " remove all in-line comments
        let qStr = qStr . " " .  substitute(line,"#.*","","")
    endfor
    let qStr = substitute(qStr,"'","\"","g")
    silent! bd! sql.tab
    let cmd = "!sql \'".qStr."\'"
    silent! execute cmd
    below split
    e sql.tab
    Tabularize/,
    wincmd k
    resize 10
endfu

" Mapping
nnoremap <buffer><leader>p  :call SQLLine()<CR>
nnoremap <buffer><S-CR>     :call SQLLine()<CR>

iab <buffer> select SELECT
iab <buffer> Select SELECT * FROM
iab <buffer> from FROM
iab <buffer> where WHERE
iab <buffer> count COUNT
iab <buffer> limit LIMIT
iab <buffer> group GROUP
iab <buffer> and AND
iab <buffer> join JOIN
iab <buffer> show SHOW
iab <buffer> as AS
iab <buffer> on ON

setlocal dictionary+=~/Documents/txt/sql/reserved
setlocal dictionary+=~/Documents/txt/sql/tables
setlocal dictionary+=~/Documents/txt/sql/views
setlocal dictionary+=~/Documents/txt/sql/Household
setlocal dictionary+=~/Documents/txt/sql/Individual
setlocal dictionary+=~/Documents/txt/sql/Meta

set foldlevel=3
inoremap <buffer> <C-SPACE> <C-x><C-k>
