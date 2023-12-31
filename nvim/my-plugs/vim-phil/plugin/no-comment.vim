" <S-Space> to toggle local comment on/off

function! ToggleComment(c)
  " Toggles the comment character `c`
  " add `# ` in any case
  " if the result is `# #` it was a comment already → remove `# #`
  " s/\(^\s*\)\s\?/\1# /
  " s/\(\s*\)# #\s\?/\1/
  " the special treatment of / / is not clean but needed because of a
  " complete escaping mess otherwise
  if a:c == '//'
    execute "s/\\(^\\s*\\)\\s\\?/\\1\\/\\/ /"
    execute "s/\\(\\s*\\)\\/\\/ \\/\\/\\s\\?/\\1/"
  else
    execute "s/\\(^\\s*\\)\\s\\?/\\1".a:c." /"
    execute "s/\\(\\s*\\)".a:c." ".a:c."\\s\\?/\\1/"
  endif
  normal j
endfunction

if !exists("g:comment_leader")
  let comment_leader = "#"
endif
execute expand("nnoremap <buffer><S-SPACE> :silent! call ToggleComment('".g:comment_leader."')<CR>")
execute expand("iabbrev <buffer> // ".g:comment_leader)

" to load this plugin after `comment_char` was changed
let commentOn = "so ".expand("<sfile>")
