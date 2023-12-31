" Author: Phil Grunewald
" Date: 15 May 23
" Revision: 
"   15 May 23: Linters
"   14 Jun 23: Linters disables :)

" Plugged
  call plug#begin('$NVIM/plugged')
  " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  " Plug 'junegunn/fzf.vim'
  " vim in browser:
  Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

  Plug 'jamessan/vim-gnupg'
  Plug 'chrisbra/colorizer'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-surround'
  Plug 'godlygeek/tabular'
  Plug 'rickhowe/diffchar.vim'
  Plug 'tommcdo/vim-exchange'
  " Plug 'airblade/vim-gitgutter'
  Plug 'github/copilot.vim'
  Plug 'ron89/thesaurus_query.vim'
  "     Linters
  Plug 'dense-analysis/ale'

  "
  " my own
  Plug '$NVIM/my-plugs/top-table'
  Plug '$NVIM/my-plugs/vim-py-kid'
  Plug '$NVIM/my-plugs/vi-sper'
  Plug '$NVIM/my-plugs/vim-bib'
  Plug '$NVIM/my-plugs/vim-sql'
  Plug '$NVIM/my-plugs/vim-mkd'
  Plug '$NVIM/my-plugs/vi-si-weg'
  Plug '$NVIM/my-plugs/vi-brarian'
  Plug '$NVIM/my-plugs/vim-phil'
  Plug '$NVIM/my-plugs/mutti'
  call plug#end()

" Neovim
  set runtimepath^=$NVIM
  set runtimepath^=$HOME
  " for OneDrive stuff
  set path^=/Users/pg/Library/CloudStorage/OneDrive-SharedLibraries-UniversityCollegeLondon/Bartlett.EDOL\\\ -\\\ Documents/
  set path^=$HOME

  " let &packpath = &runtimepath

  "avoid nested sessions
  let $VISUAL="nvr"
  let $EDITOR="nvr"
  let g:python3_host_prog = '~/.config/python/p10/bin/python'

  " let g:ale_linter_aliases = {'mkd': 'markdown', 'mutti': 'markdown'}
  let g:ale_enabled = 0

" iTerm
  " key mappings
  map ✠ <S-Space>
  map! ✠ <S-Space>
  vmap ✠ <S-Space>
  map ✡ <C-Space>
  map! ✡ <C-Space>
  vmap ✡ <C-Space>

" Appearance
  highlight StatusLine   ctermfg=black ctermbg=DarkGreen cterm=NONE
  highlight StatusLineNC ctermfg=gray  ctermbg=black     cterm=NONE
  highlight EndOfBuffer  ctermfg=black ctermbg=black
  highlight LineNr                     ctermfg=Darkgray
  highlight FoldColumn ctermbg=black ctermfg=Darkgray
  highlight Folded     ctermbg=black ctermfg=Darkgray
  highlight SignColumn ctermbg=black                   "gitgutter
  " diff highlighting - the default sucks 
  highlight DiffChange cterm=underline ctermfg=white ctermbg=none
  highlight DiffAdd    cterm=bold      ctermfg=green ctermbg=none
  highlight DiffDelete cterm=undercurl,bold      ctermfg=red   ctermbg=none

" Settings
  set mouse=            " 26 Oct 23 - mouse had started interacting with vim?! this stops that
  set modeline          " enables `# vim: set xy` instructions in files
  set wildmenu          " show options on 'tab'
  set autoread          " don't confirm 'reload file'
  set laststatus=2      " global statusline
  set clipboard=unnamed " copy to system clipboard
  set noswapfile        " more hassle than help
  set number relativenumber  " line numbering
  set diffopt+=vertical       "force vertical spits for diff
  set spell spelllang=en_gb
  set spellfile=~/.config/nvim/spell/en.utf-8.add
  set autoindent breakindent
  set list              " to display <Tab> and others
  set tabstop=2 softtabstop=2 expandtab shiftwidth=2 smarttab
  " set foldmethod=indent 
  " foldlevel=0
  set linebreak        " don't break mid-word
  set ignorecase
  set splitright

" Quitting
  command! Q     :qa!
  imap qq        <ESC>:wq!<CR>
  nmap qq        :wq!<CR>
  nmap QQ        :q!<CR>

" Mappings
  " delete buffer but keep the split
    nmap <Leader>d :b#<bar>bd#<CR>
  " insert FILE path and name
    nmap \fy :let @"=expand("%:p")<CR>""p
  " grap the lot!
    nmap ya  maggVGy`a

  " Diff
    command! Diff       windo diffthis
    nnoremap dp         :diffput<CR>
    nnoremap dg         :diffget<CR>

  " Window management
    noremap <S-LEFT>    :vertical resize -5<CR>
    noremap <S-UP>      :resize +5<CR>
    noremap <S-DOWN>    :resize -5<CR>
    noremap <S-RIGHT>   :vertical resize +5<CR>

    noremap <C-LEFT>    :wincmd h<CR>
    noremap <C-UP>      :wincmd k<CR>
    noremap <C-DOWN>    :wincmd j<CR>
    noremap <C-RIGHT>   :wincmd l<CR>

  " Shortcuts jj ::
    imap ::        <Esc>:
    imap jj        <ESC>:silent update <bar> nohlsearch<CR>
    " auto complete
    inoremap <C-Space> <C-x><C-n>

  " Jump to  mark and insert in its place
    inoremap <C-j>     <Esc>/<++><CR>va<"xc
    nnoremap <C-j>     /<++><CR>va<"xc

  " navigating
    " Switch the default: move up visual lines unless g'ed
      noremap k   gk
      noremap gk  k
      noremap j   gj
      noremap gj  j
    " bring eof to centre
      nmap    G   Gzz
    " find next and bring to centre
      nmap    n   nzz
  " quick folding
      nmap <Space>      za
  " Indent
      noremap <S-TAB> <<
      noremap <TAB> >>
      vnoremap <TAB> >gv
      vnoremap <S-TAB> <gv
  " Bubble
      nmap <Up> ddkP
      nmap <Down> ddp
      vmap <Up> xkP`[V`]
      vmap <Down> xp`[V`]

" Visual mode mappings
  " Search for selected text, forwards or backwards.
  vnoremap <silent> * :<C-U> let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>gvy/<C-R><C-R>=substitute(escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>gV:call setreg('"', old_reg, old_regtype)<CR>

" Commands 
  command! -nargs=1 Find        :Ggrep <args> | :copen | :cc

  command! German     set spelllang=de
  command! English    set spelllang=en_gb 

  command! Sql        set filetype=sql
  command! Log        e ~/Documents/txt/notes.log
  command! Todo       e ~/Documents/txt/todo/todo.log
  command! Bib        vs ~/Documents/txt/master.bib
  command! Init       e $NVIM/init.vim
  command! PWD        lcd %:p:h
  command! Home       cd ~/Documents/txt/
  command! Python     FloatermNew ipython

  command! Keys       :vs ~/.config/via/layout.md | :set foldlevel=6 | :vertical resize 45 | :wincmd h
  " command! Browser    !open -a chrome %:p:s?\(.\{-}/\)\{4}?http://localhost/?
  command! NRead      :execute '!ndown read %'
  command! NWrite     :execute '!ndown write % &'

  autocmd FileType help wincmd L
