set iskeyword+=_

set nonumber
set norelativenumber

if exists("g:comment_leader")
  let g:comment_leader = "%"
  execute commentOn
endif

" Tell ALE to treat this as a markdown file and make text suggestions /
" grammar checks...
let g:ale_linter_aliases = {'mkd': 'markdown'}
nmap ]] :ALENext<CR>

" auto underline
  inoremap --<CR> <Esc>k"kyy"kpVr-ji
  inoremap ==<CR> <Esc>k"kyy"kpVr=ji

" Toggle / increment
  nnoremap ++ <C-a>
  nnoremap -- <C-x>
  nnoremap <C-a> :call Toggle('+')<CR>
  nnoremap <C-x> :call Toggle('-')<CR>
  function! Toggle(change)
      let cStr = matchstr(getline('.'), '\%' . col('.') . 'c.')
      if (cStr == "-")
          if (a:change == '+')
              normal ciw✓
          else
              normal ciwo
          endif
      elseif (cStr == "o")
          normal ciw✓
          normal ddmo
          /^# DONE\n/
          normal j
          r! date "+\%d \%b \%Y"
          normal p`o
      elseif (cStr == "✓")
          normal ciwo
      elseif (a:change == '+')
          normal ++
      elseif (a:change == '-')
          normal --
      endif
  endfunction

function! DiffThis()
    " git diff --word-diff -U1000 | tail -n +6 > diff.txt
    %s/{+/ \\color{OliveGreen} /g
    %s/\[-/ \\color{Maroon} /g
    %s/-\]/ \\color{black} /g
    %s/+}/ \\color{black} /g
endfunction

function! PhilMarkdownFolds(lnum)
  let underline = getline(a:lnum+1)
  let line = getline(a:lnum)

  if ( underline =~ '^==\+\s*' ) || (line =~ '^# .*$')
      return '0'
  elseif ( underline =~ '^--\+\s*' ) || (line =~ '^## .*$')
      return '1'
  elseif (line =~ '^        .*')
      return '6'
  elseif (line =~ '^      .*')
      return '5'
  elseif (line =~ '^    .*')
      return '4'
  elseif (line =~ '^  .*')
      return '3'
  else
      return '2'
  endif
endfunction

" Folding
  setlocal foldexpr=PhilMarkdownFolds(v:lnum)
  setlocal foldmethod=expr
  setlocal tabstop=2 softtabstop=2 expandtab shiftwidth=2 smarttab breakindent
  setlocal foldenable
  setlocal foldlevel=4
  setlocal foldcolumn=0

inoremap <TAB> <C-t>
inoremap <S-TAB> <C-d>

setlocal formatoptions+=croql
setlocal formatoptions-=1
setlocal comments=:-

function! Process(format)
  PWD
  "silent! %s/    / \\hfill /
  write
  " .pandoc/templates/
  let number = "--number-sections"
  let csl = "--csl energy-for-sustainable-development"
  let csl = ""
  " --csl looks in ~/.pandoc/csl/ folder
  "  get citation styles from https://www.zotero.org/styles
  "  options: nature energy-economics.csl
  let cmd_bib = "python -c \"import bib; bib.md2bib('%:p')\""
  let cmd_md = 'python3 ~/.config/python/mdFilter.py '.expand('%').' '.a:format
  let cmd_pdc = 'pandoc -s -f markdown+smart+multiline_tables --variable urlcolor=blue --biblio '.expand('%:r').'.bib --citeproc '.csl.' '.number.' .'.expand('%').' -o '.expand('%:r').'.'.a:format
  silent! bd! term*python " kill previous python terminals "
  vertical split
  execute 'terminal '.cmd_bib.' && '.cmd_md.' && '.cmd_pdc
  wincmd h
endfunction

function! BibMd()
  PWD
  write
  execute "!python -c \"import bib; bib.md_link_bib('%:p')\""
  execute '!pandoc -s -f markdown+smart+multiline_tables --variable urlcolor=blue --biblio '.expand('%:r').'.bib --citeproc  --number-sections '.expand('%').' --to=markdown-citations -o '.expand('%:r').'.md'
    echo "processed"
endfunction

function! ProcessEPSRC()
  PWD
  write
  silent execute "!python -c \"import bib; bib.md2bib('%:p')\""
  silent execute '!python3 ~/.config/python/mdFilter.py '.expand('%')
  execute '!pandoc -s -f markdown+smart --reference-doc ~/.config/templates/epsrc.docx --variable urlcolor=blue --biblio '.expand('%:r').'.bib --citeproc .'.expand('%').' -o '.expand('%:r').'.docx'
  echo "processed"
endfunction

function! ProcessLaTeX()
    PWD
    w
    silent! bd! term*pandoc " kill previous pandoc terminals "
    below split
    resize 5
    terminal echo "LaTeX run " % && pandoc --natbib --template=article.tex % -o %:r.tex && pdflatex %:r && bibtex %:r && pdflatex %:r && pdflatex %:r %% && pdflatex %:r.tex && echo "Done"
    " terminal echo "LaTeX run " % && pandoc --natbib --template=elsevier.tex % -o %:r.tex && latex %:r && bibtex %:r && latex %:r && latex %:r %% && pdflatex %:r.tex && echo "Done"
    :wincmd k
endfunction

function! MakeWeb(site)
  let filename = expand('%:p')
  let filename = substitute(filename,"\(.\{-}/\)\{3}", "http://localhost", "")
  let filename = substitute(filename,".md", ".html", "")
  let filename = substitute(filename,"_src", "site", "")
  let path = expand('%:p:h')
  let folder = substitute(path, '.*_src', '', '')
  let cmd = 'terminal cd ~/Sites/'.a:site.'/_res && python post-update '.folder.' && open -a chrome http://localhost/'.a:site.'/site/'.folder
  silent! bd! term* " kill previous terminals "
  vertical split
  execute cmd
  wincmd h
  vertical resize 120
endfunction

command! BibMd  :call BibMd()

command! Pandoc     :call Process('pdf')
command! PandocPdf  :call Process('pdf')
command! PandocDoc  :call Process('docx')
command! PandocHtml :call Process('html')
command! PandocEPSRC :call ProcessEPSRC()
command! PandocTex  :call ProcessLaTeX()

command! PandocCV :execute '!python typeset.py %:t'
command! PandocEPUB :execute '!pandoc % -o %:r.epub'

nnoremap <buffer><leader>p  :Pandoc<CR>
nnoremap <buffer><S-ENTER>  :Pandoc<CR>
inoremap <buffer><S-CR>     <ESC>:wq<CR>

command! Pdf        :execute '!open -a Skim %:r.pdf'
command! Help  :h vim-mkd
