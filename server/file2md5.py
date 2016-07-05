import hashlib

# Speichereffiziente Implementierung von file2md5
# Siehe auch: https://tinyurl.com/h9a3s4c
def hashfile(afile, hasher=hashlib.md5(), blocksize=65536):
    buffer = afile.read(blocksize)
    while len(buffer) > 0:
        hasher.update(buffer)
        buffer = afile.read(blocksize)
    return hasher.hexdigest()
	
# Beispielimplementierung:
# _file = open("TinyCore-current.iso","rb")
# print(hashfile(_file))
# -> 2298e7b6d1055921aa80983fb31bb933