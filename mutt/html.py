#!/usr/bin/env python3

import sys
import shutil

def get_html(path):
    target = 'file:///Users/pg/.mutt/temp.html'
    print(target)
    shutil.copy(path,'/Users/pg/.mutt/temp.html')

if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1].startswith('-'):
        sys.stderr.write("Usage: %s <filename.html>\n" % sys.argv[0])
        sys.exit(2)
    get_html(sys.argv[1])
