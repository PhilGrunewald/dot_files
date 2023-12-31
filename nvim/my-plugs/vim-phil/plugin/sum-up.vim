" display sums
" 1) Visual selection + `S`
" 2) Inline `===`

function! Sum(values)
  " sums up visual selection
  " space and comma separated rows also add up
  let cnt = 0
  let s = 0
  for row in split(a:values,'\n')
    for col in split(row,' ')
      let s = s + str2float(col)
      if ((col == '0') || (str2float(col) != 0))
        let cnt = cnt + 1
      endif
    endfor
  endfor
  let avg = s / cnt
  let @+ = join([s])
  echo join(["Sum:", s, " Avg: ", s/cnt, "             (", cnt,"values. Sum yanked )"])
endfunction

vnoremap S "ay :call Sum(@a)<CR>
" calculate line
inoremap === <ESC>0y$A=<C-R>=<C-R>0<CR>
