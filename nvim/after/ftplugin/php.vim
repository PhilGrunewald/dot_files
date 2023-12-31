" set omnifunc=htmlcomplete#CompleteTags
nnoremap <buffer><S-ENTER>  :Browser<CR>

if exists("g:comment_leader")
  let g:comment_leader = '#'
  execute commentOn
endif
