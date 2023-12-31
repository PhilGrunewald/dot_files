" restore all tailing `\` for multiline entries
" silent exe "%s/\\\t/\t\\/"

" turn mutt aliases into `tsv` format
silent! exe "2,$s/^alias /alias<TAB>/g"
silent! exe "2,$s/<TAB>[^ ]*\\zs \\ze/\t/"
silent! exe "2,$s/<TAB>/\t/"
silent! exe "2,$s/ </\t</g"
silent! exe "2,$s/>[^\t]/>\t/g"
exe "g/# vim/d"
normal Go
normal p
