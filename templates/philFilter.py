#!/usr/bin/env python
from pandocfilters import toJSONFilter, Para, Emph, RawInline, RawBlock, Str

"""
XXX panflute is more pythonic
XXX try http://scorreia.com/software/panflute/
XXX

run with 
> pandoc --filter=philFilter.py ...

Formating

. green text with dot space
_ red text with underscore space
text in _italic type_ is green
// comments are omitted
%  as are these comments
as are lines following straight on

Numbering of Figures
Figure #figFile > Figure 1
for:
![Caption](../figs/figFile.png)

"""


def philFormat(k, v, fmt, meta):
    # for tracing what this json looks like...
    global figList, newList
    # f= open('myJSON.txt','a')
    # f.write(str(v) + "\n")
    # f.close()

    if k == 'Image':
        fileName = v[-1][0].split('/')[-1]  # after /
        fileName = fileName.split('.')[0]   # before .jpg / .pdf
        newList.append(fileName)

    if k == 'Str' and v[0] == '#':
        if v[1:] in figList:
            return Str(str(figList.index(v[1:])+1))

    if k == 'Emph':
        return [RawInline('tex', '\\color{OliveGreen}')] + [Emph(v)] + [RawInline('tex', '\\color{black}')]
    elif k == 'Para':
        if v[0]['c'][0] == '%':
            return []
        elif v[0]['c'] == '//':
            return []
        elif v[0]['c'] == '.':
            return [RawBlock('tex', '\\color{OliveGreen}')] + [Para(v[1:])] + [RawBlock('tex', '\\color{black}')]
        elif v[0]['c'] == '_':
            return [RawBlock('tex', '\\color{Maroon}')] + [Para(v[1:])] + [RawBlock('tex', '\\color{black}')]

if __name__ == "__main__":
    figList = []
    newList = []
    try:
        with open(".figs.txt", "r") as f:
            for fig in f:
                figList.append(fig.strip())
    except:
        figList = []
    toJSONFilter(philFormat)
    with open(".figs.txt", "w") as f:
        for fig in newList:
            f.write(fig + "\n")
