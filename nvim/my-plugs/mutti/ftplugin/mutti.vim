setlocal iskeyword+=.,@-@,-
setlocal dictionary+=~/Mail/addresses/aliases.tab
setlocal dictionary+=~/Mail/addresses/received
setlocal dictionary+=~/Mail/addresses/sent_to

setlocal wrap
setlocal textwidth=0
setlocal wrapmargin=0

let g:ale_linter_aliases = {'mutti': 'markdown'}

colorscheme desert

" --------------------
"      Mappings
" --------------------

" complete email addresses from dictionaries (above)
inoremap <buffer> <S-Tab> <C-x><C-k>

inoremap <buffer> yy <ESC>G"ayggoBcc: philipp.grunewald@eng.ox.ac.uk<ESC>:wq<CR>
inoremap <buffer><S-CR> <ESC>G"ayggoBcc: philipp.grunewald@eng.ox.ac.uk<ESC>:wq<CR>
inoremap <buffer> qq <ESC>:q!<CR>

" --------------------
"     Formatting
" --------------------

function! TidyHeaders()
  " Remove/amend empty fields
  " avoid ''search reached BOTTOM message:''
  " [ ]\? means one space or none - mutt has one space, neoMutt has none
  set shm+=s
  let temp = @*
  1g/From:.*/d
  g/Cc:[ ]\?$/de
  g/Reply-To:[ ]\?$/de
  %s/To:[ ]\?$/To: <++>/
  %s/Subject:[ ]\?$/Subject: <++>/
  let @* = temp
endfunction

silent! call TidyHeaders()


" --------------------
"    Ranger attach
" --------------------

function! RangerMuttAttach()
  normal ma
  execute "terminal ranger ~/Documents/Oxford --choosefiles=/tmp/chosenfiles"
endfunction

fu AttachRangerFiles()
  " called on BufWinEnter ftdetect
  if filereadable('/tmp/chosenfiles')
    call system('sed "s/[[:space:]]/\\\ /g" /tmp/chosenfiles | sed "s/\(.*\)/Attach: \1/" > /tmp/muttattach')
    normal gg
    exe "/Subject"
    " normal o
    exec 'read /tmp/muttattach'
    call system('rm /tmp/chosenfiles /tmp/muttattach')
    normal `a
  endif
  redraw!
endfunction

map <buffer><leader>a :call RangerMuttAttach()<CR>a


" --------------------
"    Jump to Insert
" --------------------

" go to end of paragraph '}' and insert on first line
normal gg}O
startinsert
