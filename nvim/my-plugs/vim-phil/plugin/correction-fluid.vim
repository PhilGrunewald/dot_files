" quick spell
    inoremap ,,         <C-O>:call CorrectionFluid()<CR>
    " @l is the distance from end of line. @c returns to this point, which won't
    " have changed, even if the spell correction made the line longer or shorter.
    " A simple 'mark' would have been misplaced.
    " Multiline seem to count \n's -> nowrap during transaction
       " mx    mark the cursor position
       " [s    find most recent mistake
       " 1z=   correct with most common suggestion
       " `x    return to x
    function! CorrectionFluid()
      let wrap = &wrap
      set nowrap
      normal mx
      let @l=col("$")-col(".")
      normal [s1z=
      let @/=expand("<cword>")
      normal `x
      let @c=col("$")-@l
      execute "normal @c|"
      if wrap == 1 | set wrap | endif
    endfunction

" Highlighting
" Statusline
     " highlight StatusLine ctermfg=black     ctermbg=red     cterm=NONE
     " highlight StatusLineNC ctermfg=darkgray  ctermbg=gray     cterm=NONE
	
" Spelling
     hi clear SpellBad
     hi clear SpellLocal
     hi clear SpellCap
     hi clear SpellRare
     hi SpellBad ctermbg=NONE cterm=underline 
     hi SpellLocal cterm=underline
