" all my comments as //
if exists("g:comment_leader")
  let g:comment_leader = "%"
  execute commentOn
endif

function! Process()
    terminal pdflatex % && bibtex %:p:r && pdflatex % && pdflatex %
endfunction

" Commands
command! Typeset !pdflatex %<CR>

" Mapping
nnoremap <buffer><leader>p		:Typeset<CR><CR>
nnoremap <buffer><S-ENTER>		:call Process()<CR>
