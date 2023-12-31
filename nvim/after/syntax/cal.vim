
hi Year ctermfg=DarkRed cterm=bold,underline guifg=DarkRed
hi Month ctermfg=Red cterm=bold,underline guifg=Red
hi Day ctermfg=Blue cterm=bold,underline guifg=Blue
hi Week ctermfg=Green cterm=bold,underline guifg=Blue

syn match  Year  /^2.*/
syn match  Month  /^ \zs[^ ].*\ze/
syn match  Day  /^   \zs\d.*\ze/
syn match  Week  /^  \zs__.*\ze/
