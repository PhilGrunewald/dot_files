" Save buffer with first line as file name
" Write file to notes.log

command! Save call SaveFirstLine()
nnoremap \fn :<C-U>call WriteLog('notes')<CR>

fu! SaveFirstLine ()
    let fileName = strftime("%y_%m_%d_") . substitute(getline(1),"@","_","g")
    execute 'sav! '.substitute(fileName," ","_","g").'.md'
    call WriteLog('notes')
endfu

function! WriteLog(fileName)
  " add current file with timestamp to log file
  let lfname = substitute(expand('%:p'),$HOME.'/',"","") . ' (' . strftime('%d %b %Y') . ')'
  silent execute '!echo "'.lfname.'" >> $HOME/Documents/txt/'.a:fileName.'.log'
  Gwrite
  redraw
  echomsg 'Added' lfname 'to ' a:fileName'.log and git'
endfunction
