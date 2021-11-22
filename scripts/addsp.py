import re

SRC = 'temp/hmm/hmm3/hmmdefs'
DST = 'temp/hmm/hmm4/hmmdefs'

text = open(SRC, 'r').read()

sil = re.search(r'~h "sil"[\d\w\s<>\-\.+]*$', text)
sil = sil.group(0)

sp = re.sub(r'sil', r'sp', sil)
sp = re.sub(r'<STATE> 2[\d\w\s<>\-\.+]*(?=<STATE> 3)', '', sp)
sp = re.sub(r'<STATE> 4[\d\w\s<>\-\.+]*(?=<TRANSP>)', '', sp)
sp = re.sub(r'(?<=<NUMSTATES>\s)\d', '3', sp)
sp = re.sub(r'(?<=<STATE>\s)\d', '2', sp)
sp = re.sub(r'(?<=<TRANSP>\s)\d', '3', sp)
sp = re.sub(
    r'(?<=<TRANSP> 3\s)[\d\w\s<>\-\.+]*(?=<ENDHMM>)', 
    '\n'.join([
        ' 0.0 1.0 0.0',
        ' 0.0 0.9 0.1',
        ' 0.0 0.0 0.0\n'
    ]), 
    sp
)

dest = open(DST, 'a')
dest.write(sp)