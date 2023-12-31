" Cycle through buffers with <Left> and <Right>

noremap <LEFT>    :call GoPrevious()<CR>
noremap <RIGHT>   :silent! call GoNext()<CR>

function! GoPrevious()
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && bufname(v:val) =~ "^term*"')
  if !empty(buffers)
      exe 'bd! '.join(buffers, ' ')
  endif
  bprevious!
endfunction

function! GoNext()
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && bufname(v:val) =~ "^term*"')
  if !empty(buffers)
      exe 'bd! '.join(buffers, ' ')
  endif
  bnext!
endfunction
