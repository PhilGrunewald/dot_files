au BufRead,BufNewFile *.md  setlocal filetype=mkd
au BufRead,BufNewFile *.log setlocal filetype=mkd
au BufRead,BufNewFile *.txt setlocal filetype=mkd

" au BufRead,BufNewFile *digest/_src/*.md  nnoremap <buffer><S-CR>  :!cd /Users/pg/Sites/energy-use.org/public_html/digest/_res && python post-update<CR>
" au BufRead,BufNewFile ~/Sites/edol.uk/_src/*.md  nnoremap <buffer><S-CR> :!cd ~/Sites/edol.uk/_res && python post-update<CR>
au BufRead,BufNewFile ~/Sites/energy-use.org/_src/*  nnoremap <buffer><S-CR> :call MakeWeb('energy-use.org')<CR>
au BufRead,BufNewFile ~/Sites/edol.uk/_src/*    nnoremap <buffer><S-CR> :call MakeWeb('edol.uk')<CR>
au BufRead,BufNewFile *digest/_src/*    nnoremap <buffer><S-CR> :call MakeWeb('energy-use.org/public_html/digest')<CR>
