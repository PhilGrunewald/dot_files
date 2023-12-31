"syntax off
hi BibDeclare   ctermbg=Black ctermfg=DarkGray
hi CiteKey      ctermbg=None  ctermfg=DarkGreen
hi Conceal      ctermbg=None  ctermfg=NONE
highlight Folded ctermbg=black ctermfg=white

" Conceal paths
syn match BibDeclare      "^\s\+\S*"
syn match CiteKey         "\w*,$"

set conceallevel=1
set concealcursor=
set foldlevel=0
set shiftwidth=2

"syn match BibType         "^@.*{" conceal cchar= 
syn match BibType         "^@.*{" conceal cchar=@
syn match BibDecorator    "= {" conceal cchar= 
syn match BibDecorator2   "}" conceal cchar= 
syn match BibDecorator3   ",$" conceal cchar= 

let b:current_syntax = "phil_bib"


