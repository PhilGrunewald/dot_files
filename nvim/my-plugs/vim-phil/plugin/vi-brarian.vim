" bib lookup
" setlocal omnifunc=Vibrarian
" auto omnicomplete after @
"imap @ @<C-x><C-o><BS>

let g:bibFile = '/Documents/txt/master.bib'

function! Vibrarian(findstart, base)
    if a:findstart
         " return the starting position of the word
         let line = getline('.')
         let pos = col('.') - 1
         while pos > 0 && line[pos - 1] !~ '\\\|{\|\[\|<\|\s\|@\|\^'
             let pos -= 1
         endwhile
         let line_start = line[:pos-1]
         return pos
    else
        "return suggestions in an array
        let suggestions = []
        let suggestions = BibSuggestions(a:base)
        return suggestions
    endif
endfunction


python3<<EOF
#! /usr/local/bin/ python3
import vim
import re
from os.path import basename
from operator import itemgetter
from subprocess import Popen, PIPE


def bib_suggestions(text, query):
    entries = []
    bibtex_id_search = re.compile(".*{\s*(?P<id>" + query + ".*),")
    bibtex_author_search = re.compile("^\s*[Aa]uthor\s*=\s*{(?P<author>\S.*?)}.{,1}\n", re.MULTILINE | re.DOTALL)
    bibtex_title_search = re.compile("^\s*[Tt]itle\s*=\s*{(?P<title>\S.*?)}.{,1}\n", re.MULTILINE | re.DOTALL)
    bibtex_year_search = re.compile("^\s*[Yy]ear\s*=\s*{(?P<year>\S.*?)}.{,1}\n", re.MULTILINE | re.DOTALL)
    bibtex_journal = re.compile("^\s*[Jj]ournal\s*=\s*{(?P<journal>\S.*?)}.{,1}\n", re.MULTILINE | re.DOTALL)

    for entry in [i for i in re.split("\n@", text)]:
        entry_dict = {}
        i1 = bibtex_id_search.match(entry)
        if i1:
            entry_dict["word"] = i1.group("id")
            # search for title
            i2 = bibtex_title_search.search(entry)
            if i2:
                title = i2.group("title")
            else:
                title = ""
            title = re.sub("[{}]", "", re.sub("\s+", " ", title))
            # search for author
            i4 = bibtex_author_search.search(entry)
            if i4:
                author = i4.group("author")
                author = re.sub(r"{.*}","?",author)
                author = re.sub(r"\\.","",author)
            else:
                author = 'no author'
            journal = bibtex_journal.search(entry)
            if journal:
                journal = journal.group("journal")
            year = bibtex_year_search.search(entry)
            if year:
                year = year.group("year")
            entry_dict["menu"] = f"{author} ({year})"
            entry_dict["info"] = f"{title} ({journal})"
            entries.append(entry_dict)
    return entries
EOF

function! BibSuggestions(partkey)
python3<<EOF
from pathlib import Path
bib = str(Path.home()) + vim.eval("g:bibFile")
query = vim.eval("a:partkey")
matches = []
with open(bib) as f:
    text = f.read()
ids = []
ids = bib_suggestions(text, query)
matches.extend(ids)
matches = sorted(matches, key=itemgetter("word"))

vim.command("return " + re.sub(r'\\x\w{2}', '', str(matches)))
EOF
endfunction
