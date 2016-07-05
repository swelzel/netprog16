import hashlib

# Speichereffiziente Implementierung von file2md5
# Siehe auch: https://tinyurl.com/h9a3s4c
def hashfile(afile, hasher, blocksize=65536):
    buffer = afile.read(blocksize)
    while len(buffer) > 0:
        hasher.update(buffer)
        buffer = afile.read(blocksize)
    return hasher.digest()

[(fname, hashfile(open(fname, 'rb'), hashlib.md5())) for fname in fnamelst]