import os

PATH_TO_HMM0 = 'temp/hmm/hmm0'

proto = open(f"{PATH_TO_HMM0}/proto", 'r').readlines()
vfloors = open(f"{PATH_TO_HMM0}/vFloors", 'r').readlines()

hmmdefs = open(f"{PATH_TO_HMM0}/hmmdefs", 'r').readlines()
hmmdefs = list(map(lambda phonem: ''.join(proto[3:]).replace("proto", phonem.strip()), hmmdefs))
hmmdefs_file = open(f"{PATH_TO_HMM0}/hmmdefs", 'w').writelines(hmmdefs)

macros = proto[:3].copy()
macros.extend(vfloors)
macros_file = open(f"{PATH_TO_HMM0}/macros", 'w').writelines(macros)