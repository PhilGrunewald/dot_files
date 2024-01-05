command! AR call TakeAction()

fu! TakeAction()
  let line = substitute(getline('.'), '^AR ', '', '')
  let action = 'o '.line.' '.strftime("  (%d %b %y)").'\t in: '.expand('%:r')
  execute "!sed -i '' '3s/^/".action."\\n/' $HOME/Library/CloudStorage/Dropbox-Personal/text/todo.md"
  echomsg 'Action: "'.getline('.').'" taken'
endfu
