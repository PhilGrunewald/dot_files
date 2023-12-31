# import renew
import pandas as pd

bibFile = '/Users/pg/Documents/txt/master.bib'

def getBib(bibFile='/Users/pg/Documents/txt/master.bib'):
    """ returns dataframe of bib with ctiekey as index """
    d = {}
    with open(bibFile, 'r') as bib:
        for line in bib.readlines():
            if line.startswith('@'):
                print(line)
                key = line.split('{')[1].split(',')[0]
                kind = line.split('@')[1].split('{')[0]
                d[key] = {}
                d[key]['bibtype'] = line.split('@')[1].split('{')[0]
            else:
                entry = line.split(' = ')
                if len(entry) > 1:
                    d[key][entry[0].strip()] = entry[1]
    return pd.DataFrame.from_dict(d,orient='index').fillna('')

def scanMarkdown(fileName):
    """ extract everything that starts with @ """
    mdKeys = []
    with open(fileName, 'r') as f:
        for line in f.readlines():
            keys = line.split('@')[1:]
            for key in keys:
                key = key.split(' ')[0]
                key = key.split('.')[0]
                key = key.split(',')[0]
                key = key.split(';')[0]
                key = key.split(')')[0]
                key = key.split(']')[0]
                key = key.split('\n')[0]
                mdKeys.append(key)
    return mdKeys

def linkMarkdown(keys,fileName):
    """ extract everything that starts with @ """
    with open(fileName, 'r') as f:
        lines = f.readlines()
    for i,line in enumerate(lines):
        for key in keys:
            line = line.replace(f'@{key}',f'[@{key}](#ref-{key})')
        lines[i]=line
    with open(fileName, 'w') as f:
        f.writelines(lines)

def getBibKeys(keys):
    """ filters bib file down to a list of keys """
    bib = getBib()
    badKeys = [key for key in keys if key not in bib.index]
    print(f'WARNING:\n   {badKeys} not in {bibFile}\n')
    keys    = [key for key in keys if key in bib.index]
    return bib.loc[keys]

def find(serchterm,fields):
    bib = getBib()
    df  = pd.DataFrame()
    for field in fields:
        df = pd.concat([df,bib[bib[field].str.contains(searchterm,na=False,case=False)]])
    return df

def trim(row):
    """ trim surrounding '{ ... },' """
    for field in row.keys():
        row[field] = row[field][1:-3]
    return row

def printBib(df,txtName='.temp.txt'):
    with open(txtName,'w') as f:
        for key,row in df.iterrows():
            typ = row.bibtype
            row = trim(row)
            match typ:
                case 'article':
                    publication = row.journal
                case 'techreport':
                    publication = row.institution
            line = f'{key[:11]:12} {row.author[:20]:23} {row.title} {publication}\n'
            f.write(line)

def writeBib(df,bibName='.temp.bib'):
    with open(bibName,'w') as f:
        for key,row in df.iterrows():
            f.write(f'@{row.bibtype}{{{key},\n')
            row.bibtype = ''
            for field in row.keys():
                if row[field]:
                    value = row[field].replace('}\n','},\n')
                    f.write(f'    {field} = {value}')
            f.write('    }\n\n')

def dot(filename):
    path = filename.split('/')
    path[-1] = f'.{path[-1]}'
    return '/'.join(path)

def filter(searchterm,fields,bibFile):
    bib = getBib(bibFile)
    df  = pd.DataFrame()
    for field in fields:
        df = pd.concat([df,bib[bib[field].str.contains(searchterm,na=False,case=False)]])
    writeBib(df,dot(bibFile))

def text(bibFile):
    bib = getBib(bibFile)
    txtFile = f'{bibFile[:-3]}txt'
    printBib(bib,txtFile)

def md2bib(mdFile):
    keys = scanMarkdown(mdFile)
    df   = getBibKeys(keys)
    writeBib(df,f'{mdFile[:-3]}.bib')

def md_link_bib(mdFile):
    keys = scanMarkdown(mdFile)
    linkMarkdown(keys,mdFile)
    df   = getBibKeys(keys)
    writeBib(df,f'{mdFile[:-3]}.bib')

if __name__ == "__main__":
    searchterm = 'wald'
    fields = ['author', 'title', 'journal']
    # df = find(searchterm,fields)
    # writeBib(df)
    # printBib(df)
    keys = scanMarkdown('/Users/pg/Documents/Oxford/ReNEW/output/test.md')
    df = getBibKeys(keys)
    writeBib(df)
    # printBib(df)


