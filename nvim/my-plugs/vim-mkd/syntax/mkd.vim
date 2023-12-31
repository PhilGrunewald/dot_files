hi PGComment    ctermfg=Gray
hi PGMaroon    ctermfg=DarkRed
hi PGGreen    ctermfg=DarkGreen
hi PGImage    ctermfg=Yellow
hi PGTag        ctermbg=DarkGray
hi PGAction     ctermbg=Red
hi PGPath       ctermfg=DarkGray
hi PGCoordinates ctermfg=blue
hi PGBlank      ctermfg=Black

hi PGHeader     ctermfg=DarkGreen cterm=underline
hi PGBold       cterm=bold,underline
hi PGSubHeader  ctermfg=DarkYellow cterm=underline
hi PGSubSubHeader  ctermfg=Gray cterm=underline
hi PGLine       ctermfg=Gray
hi PGActionOn   ctermfg=Gray
hi PGActionOff  ctermfg=Red cterm=none
hi PGItalic     ctermfg=lightblue    cterm=italic ctermbg=black
hi PGCite     ctermfg=blue    cterm=italic ctermbg=black

hi Conceal      ctermbg=Black ctermfg=DarkGreen

syn region PGItalic start="\(^\|\s\)\@<=_\|\\\@<!_\([^_]\+\s\)\@=" end="\S\@<=_\|_\S\@=" keepend oneline

syn match PGBold   /\*\*\zs.\+\ze\*\*/

" Conceal paths
set conceallevel=2


syn match PGPath      "^\S\+\/" conceal cchar=>
syn match Hfill      "\\hfill" conceal cchar=▶
syn match Bullet      "^\s*\zs-\ze " conceal cchar=⚬
syn match PGCoordinates      "(\?\(https:\/\/\)\?\(www.\)\?google.com\/maps\/.*" conceal cchar=📍
syn match PGPicture      "(\?\(\/Users\/pg\/\)\?Pictures\/.*" conceal cchar=📷

syn match PGActionOn      /^✓ .\+/
syn match PGActionOff     /^o /

syn match PGTag       "\zs\S\+\ze\["

" syn match PGHeader      /^\S.\+/
syn match PGHeader   /^\zs\a.\+\ze\n  \S/ 
syn match PGSubHeader   /^  \zs\S.\+\ze\n    \S/ 
syn match PGSubSubHeader   /^    \zs\S.\+\ze\n      \S/ 

syn match PGHeader      /^\zs.\+\ze\n==/ 
syn match PGHeader      /^# .\+/
syn match PGSubHeader   /^##.\+/
syn match PGLine        /^=\+$/
syn match PGSubHeader   /^\zs.\+\ze\n--/
syn match PGLine        /^-\+$/
syn match PGMaroon      /^_ .\+$/
syn match PGGreen       /^\. .\+$/
syn match PGComment     /^%.\+$/
syn match PGComment     /^\/\/ .\+$/
syn match PGImage       /^!\[.*/

syn match PGPicture      "^\!\[\]" conceal cchar=📷

syn match PGBlank     "&nbsp;"
syn match PGAction    "^AR"
syn match PGAction    "^.*\zsXXX\ze"
syn match PGCite       "\[\?@\w\+\d\+\w\+\]\?"
"  [@Citekey19lala]

let b:current_syntax = "phil"
