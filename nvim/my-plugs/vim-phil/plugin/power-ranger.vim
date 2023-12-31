" Terminal and Ranger use

" <ESC> to get out
tnoremap <Esc> <C-\><C-n>

command! T      :call SplitTerminal('')
nmap <leader>n  :call SplitTerminal('ranger --choosedir=$HOME/.config/ranger/dir; cd `cat $HOME/.config/ranger/dir`')<CR>
nmap gr         :call SplitTerminal('ranger --selectfile <cWORD>')<CR>

function! SplitTerminal(CommandString)
    :vs
    :vertical resize 80
    :set norelativenumber
    :execute 'terminal ' a:CommandString
    :normal A
endfunction

command! Do call ShellLine()

nnoremap <C-CR> :call ShellLine()<CR>
function ShellLine()
    " execute any line as shell command
    " strip leading > % " or #
    let cmd = getline('.')
    let cmd = substitute(cmd,"^[\"#>%]","","g")
    let command = 'terminal ' . cmd
    vertical split
    execute command
    normal a
endfunction

function! RangerCD()
  " set working directory to where ranger was left
  let dir = readfile($HOME."/.config/ranger/dir")[0]
  let cmd = 'cd '.dir
  execute cmd
  echo "Changed directory to ".dir
endfunction

au BufUnload term://*ranger* :call RangerCD()
