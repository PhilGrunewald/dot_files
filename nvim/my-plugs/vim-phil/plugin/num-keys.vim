" turn home row into number row
"
imap JJ  <ESC>:call Map_numbers()<CR>a
function! Map_numbers()
  imap u 1
  imap i 2
  imap o 3
  imap j 4
  imap k 5
  imap l 6
  imap n 7
  imap m 8
  imap , 9
  imap h .
  imap p +
  imap P -
  imap ; =
  imap : ===
  inoremap <SPACE><SPACE> .
  imap . *
  imap > /
  imap <S-CR> ===

  imap U !
  imap I @
  imap O £
  imap J $
  imap K %
  imap L ^
  imap N &
  imap M *
  imap H ===
  imap q <ESC>:call Map_letters()<CR>a
  imap c  <ESC>:call Map_letters()<CR>a
  imap JJ <ESC>:call Map_letters()<CR>a
  iunmap jj
  imap ? <ESC>:KeyBlock<CR>
  highlight StatusLine   ctermfg=black ctermbg=DarkRed cterm=NONE
endfunction

function! Map_numbers_home()
  imap a 1
  imap s 2
  imap d 3
  imap f 4
  imap g 5
  imap h 6
  imap j 7
  " imap jj 77
  imap k 8
  imap l 9
  imap ; 0

  imap A !
  imap S @
  imap D #
  imap F $
  imap G %
  imap H ^
  imap J &
  imap K *
  imap L (
  imap R )
  imap I !
  imap : )
  imap q <ESC>:call Map_letters()<CR>a
  imap w £
  imap e =
  imap E ===
  imap r /
  imap t ×
  imap y *
  imap u _
  imap i \|
  imap o (
  imap p +
  imap m -
  imap b <BS>
  imap n <CR>
  imap z ===
  imap Z ===
  imap x *
  imap c  <ESC>:call Map_letters()<CR>a
  imap JJ <ESC>:call Map_letters()<CR>a
  iunmap jj
  imap ? <ESC>:Keys<CR>
  highlight StatusLine   ctermfg=black ctermbg=DarkRed cterm=NONE
endfunction

function! Map_letters()
  imap a a
  imap s s
  imap d d
  imap f f
  imap g g
  imap h h
  imap j j
  imap k k
  imap l l
  imap ; ;
  imap q q
  imap w w
  imap e e
  imap r r
  imap t t
  imap y y
  imap u u
  imap i i
  imap o o
  imap p p
  imap [ [
  imap ] ]
  imap b b
  imap n n
  imap x x
  imap c c
  imap m m
  imap z z
  imap A A
  imap S S
  imap D D
  imap F F
  imap G G
  imap H H
  imap J J
  imap K K
  imap L L
  imap : :
  imap Q Q
  imap W W
  imap E E
  imap R R
  imap T T
  imap Y Y
  imap U U
  imap I I
  imap O O
  imap P P
  imap [ [
  imap ] ]
  imap B B
  imap N N
  imap X X
  imap C C
  imap M M
  imap Z Z
  imap > >
  imap JJ    <ESC>:call Map_numbers()<CR>a
  imap jj    <ESC>:silent update <bar> nohlsearch<CR>
  imap ? ?
  highlight StatusLine   ctermfg=black ctermbg=DarkGreen cterm=NONE
endfunction

" command Keys :sp ~/.config/nvim/my-plugs/vim-phil/doc/num-keys.md | :resize 7 | :wincmd j
" command Krys :vs ~/.config/via/layout.md | :set foldlevel=6 | :vertical resize 51 | :wincmd l
command KeyBlock :sp ~/.config/nvim/my-plugs/vim-phil/doc/num-keys-block.md | :resize 7 | :wincmd j

