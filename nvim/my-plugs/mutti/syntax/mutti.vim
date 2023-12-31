let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

highlight LineNr ctermfg=Black ctermbg=none   "tone down the numbers
highlight EndOfBuffer  ctermfg=black ctermbg=black

hi clear SpellBad
hi clear SpellLocal
hi clear SpellCap
hi clear SpellRare
hi SpellBad ctermbg=NONE cterm=underline 
hi SpellLocal cterm=underline

hi PGSubject 	ctermfg	= 022	    ctermbg	= white cterm=bold 
hi mailTo 		ctermfg	= 022	    ctermbg	= white
hi mailBcc 		ctermfg	= 022	 	ctermbg	= black
hi mailCc 		ctermfg	= white	 	ctermbg	= black 
hi mailFrom 	ctermfg	= black	 	ctermbg	= black
hi mailReplyTo 	ctermfg	= 022	 	ctermbg	= black
hi Sent		 	ctermfg	= 022	 	ctermbg	= black
" hi mailInReplyTo ctermfg= 236		ctermbg	= black
hi mailInReplyTo ctermfg= white		ctermbg	= white
hi replyHeader	ctermfg = 022		ctermbg	= 236
hi divider		ctermfg = 022		ctermbg	= white
hi attach		ctermfg = 022		ctermbg	= white
hi trivia ctermfg=LightGrey guifg=#B01C2D guibg=#DADADA gui=bold,underline
hi quoted ctermfg=darkgreen guifg=#B01C2D guibg=#DADADA gui=bold,underline
"match TabLine /\%3l/
syntax match PGSubject /\%3l/
syntax match mailInReplyTo /^In-Reply-To:.*/
syntax match mailReplyTo /^Reply-To:.*/
syntax match mailTo /^To:.*/
syntax match mailCc /^Cc:.*/
syntax match mailBcc /^Bcc:.*/
syntax match mailFrom /^From:.*/
syntax match PGSubject /^Subject:.*/
syntax match attach /^Attach:.*/
syntax match Sent /^Sent:.*/
syntax match trivia /^\[.*\].*/
syntax match quoted /^>.*/
syntax match replyHeader /^On.*wrote:/
syntax match divider /^-----Original Message-----/



" so ~/.vim/phil.vim		" loads grey line numbers and tabs
