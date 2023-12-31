au BufRead,BufNewFile /private/var* setlocal ft=mutti
au BufRead,BufNewFile *.mail setlocal ft=mutti
au BufRead ~/Mail/* setlocal ft=mutti

au BufWrite /private/var* :w! ~/Mail/draft_email.mail
au BufWinEnter /private/var* :call AttachRangerFiles()
