#!/usr/bin/env python
"""
Alternative to pandoc-filter

Input 
    filename
Output
    Creates .filename which gets processed by pandoc instead

Original file is updated on figure numbers

Formating

. green text with dot space
_ red text with underscore space
text in _italic type_ is green
// comments are omitted
%  as are these comments
as are lines following straight on


"""
import sys

def commentOut(lines):
    """ remove lines starting with // or % """
    isComment = False
    for n,line in enumerate(lines):
        if (line.startswith('%') and n > 2):
            isComment = True
        elif line.startswith('//'):
            isComment = True
        elif line.startswith('\n'):
            isComment = False
        if isComment:
            lines[n] = ("")
    return lines

def de_intent(lines):
    """ add heading markers to lines that are single indent """
    level_change = False
    level = -1
    ref_line = 0
    for n,line in enumerate(lines):
        if line != "\n" and not line.startswith('  -'):
            last_level = level
            level = 1+int((len(line)-len(line.lstrip(' ')))/2)
            if level != last_level:
                if level_change:
                    heading = "#"*last_level
                    lines[ref_line] = f"\n{heading} {lines[ref_line].strip()}\n\n"
                else:
                    lines[ref_line] = f"{lines[ref_line].strip()}\n"
                level_change = True
            else:
                # if n > 0:
                lines[ref_line] = f"{lines[ref_line].strip()}\n"
                level_change = False
            ref_line = n

    return lines

def figNumbers(lines):
    """ 1) add figure filenames to list 2) replace '#filename' with number 

    Numbering of Figures
    Figure #figFile > Figure 1
    for:
    ![Caption](../figs/figFile.png)
    """
    figList = []
    for line in lines:
        if line.startswith("!["):
            filename=line.split("(")[-1]
            filename=filename.split("/")[-1]
            filename=filename.split(".")[0]
            figList.append(filename)
    for i,fig in enumerate(figList):
        for n,line in enumerate(lines):
            lines[n] = line.replace(f"#{fig}",f"{i+1}")
            # only for pdf does pandoc generate fig numbers - for others we add them to the Caption itself
            if line.startswith("![") and fig in line and sys.argv[2] != "pdf":
                lines[n] = line.replace("![",f"![Figure {i+1}: ")
    return lines

def tab_numbers(lines):
    """ 1) add table markers to list 2) replace '#tablemarker' with number 
    [… table …]
    Table: caption
    %tablemarker
    """
    tabList = []
    for n,line in enumerate(lines):
        if line.startswith("Table:") and lines[n+1].startswith("%"):
            tabList.append(lines[n+1][1:-1])
    for i,tabref in enumerate(tabList):
        for n,line in enumerate(lines):
            lines[n] = line.replace(f"#{tabref}",f"{i+1}")
            # only for pdf does pandoc generate fig numbers - for others we add them to the Caption itself
            if line.startswith("Table:") and lines[n+1][1:-1] == tabref and sys.argv[2] != "pdf":
                lines[n] = line.replace("Table:",f"Table: Table {i+1}:")
    return lines


def addColour(lines):
    """ ^. > green, ^_ > red """
    green = "\\color{OliveGreen}"
    maroon = "\\color{Maroon}"
    black = "\\color{black}"
    for n,line in enumerate(lines):
        if line.startswith(". "):
            lines[n] = f"{green}{line[2:]}{black}"
        elif line.startswith("_ "):
            lines[n] = f"{maroon}{line[2:]}{black}"
    return lines

def main(filename):
    """ Step through lines and tweak """
    with open(filename) as f:
        lines = f.readlines()
    lines = tab_numbers(lines)
    lines = commentOut(lines)
    lines = de_intent(lines)
    lines = figNumbers(lines)
    lines = addColour(lines)
    """ open filename, process and write as .filename """
    with open(f".{filename}","w") as f:
        f.writelines(lines)

if __name__ == "__main__":
    main(sys.argv[1])
