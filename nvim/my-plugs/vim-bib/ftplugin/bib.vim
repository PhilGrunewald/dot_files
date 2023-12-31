if exists("g:comment_leader")
  let g:comment_leader = "%"
  execute commentOn
endif

setlocal nowrap
" to grab full doi as <cword>
setlocal iskeyword+=.,/
setlocal foldlevel=1
setlocal foldtext=BibFold()

nnoremap <buffer><S-ENTER>  :execute '!open ~/Documents/Bib/'.expand("<cword>").'.pdf'<CR>

let path = expand('<sfile>:h')
execute "command! NewArticle :read ".path."/../doc/article.bib"
execute "command! NewTechreport :read ".path."/../doc/techreport.bib"
command! -nargs=* NewDOI    call NewDOI(<f-args>)

command! -nargs=1 BibFilter  call BibFilter(<f-args>,"['author','title']")
command! -nargs=* BibKeyword call BibFilter(<f-args>,"['keywords']")
command! -nargs=* BibYear    call BibFilter(<f-args>,"['year']")
command! -nargs=* BibAuthor  call BibFilter(<f-args>,"['author']")
command! -nargs=* BibType    call BibFilter(<f-args>,"['bibtype']")

command! BibText execute "!python -c \"import bib; bib.text('\"%:p\"')\"" | e %:r.txt

command! Help :h vim-bib

function! BibFold()
    let fs = v:foldstart
    for i in [0,1,2,3,4,5,6,7,8,9,10]
        if getline(fs+i) =~ '\s\+title.*'
            let title = substitute(getline(fs+i), '.*{', '', 'g')
            let title = substitute(title,'}','','g')
            return substitute(title, ',$', '', 'g')
        endif
    endfor
    let title = substitute(getline(fs), '.*{', '', 'g')
    let title = substitute(title,'}','','g')
    return substitute(title,',$','','g')
endf

