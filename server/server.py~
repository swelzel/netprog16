from flask import Flask , request
import hashlib, os.path
app = Flask(__name__)

global clientHashmap
clientHashmap = dict({})
global filenames
filenames = {"kernel-nvidia":"TinyCore-current.iso",
	"kernel-ati":"TinyCore-current.iso"}
global port
port = "5000"
global foldername
foldername = "tce"

@app.route("/S2C_Alive", methods=['POST', 'GET'])
def alive():
	mac = request.values.get("mac")
	#config2hashmap(request.values.get("cpu"), request.values.get("graka"), mac)
	return "True"

def config2hashmap(cpu, graka, mac):
	if(cpu == "x86"):
		if(graka == "nvidia"):
			clientHashmap[mac] = "kernel-nvidia"
		elif(graka == "ati"):
			clientHashmap[mac] = "kernel-ati"
	elif(cpu == "x64"):
		if(graka == "nvidia"):
			clientHashmap[mac] = "kernel-nvidia"
		elif(graka == "ati"):
			clientHashmap[mac] = "kernel-ati"
		
#die clientseite will selber vergleichen 
@app.route("/S2C_AnswerKernel", methods=['POST', 'GET'])
def av_Kernel():
	if(filename is None):
		return "False"
	else:
		if os.path.isfile("vmlinuz"):
			_file = open("vmlinuz","rb")
			_hash = hashfile(_file)
			_file.close()
			return _hash
		return "Error"

@app.route("/S2C_SendKernel", methods=['POST', 'GET'])
def kernel():
	return "http://"+str(request.remote_addr)+":"+port+"/vmlinuz"

@app.route("/S2C_AnswerCore", methods=['POST', 'GET'])
def av_Core():
	if(filename is None):
		return "False"
	else:
		if os.path.isfile("core.gz"):
			_file = open("core.gz","rb")
			_hash = hashfile(_file)
			_file.close()
			return _hash
		return "Error"

@app.route("/S2C_SendCore", methods=['POST', 'GET'])
def core():
	return "http://"+str(request.remote_addr)+":"+port+"/core.gz"

@app.route("/S2C_AnswerPackage", methods=['POST', 'GET'])
def av_Package():
	packagename = request.values.get("packagename")
	if(packagename is None):
		return "False"
	else:
		if os.path.isfile(foldername+"/"+packagename):
			_file = open(foldername+"/"+packagename,"rb")
			_hash = hashfile(_file)
			_file.close()
			return _hash
		return "Error"

@app.route("/S2C_SendPackage", methods=['POST', 'GET'])
def package():
	packagename = request.values.get("packagename")
	if(packagename is None or not os.path.isfile(foldername+"/"+packagename)):
		return "Error"
	return "http://"+str(request.remote_addr)+":"+port+"/"+foldername+"/"+str(packagename)

def hashfile(afile, blocksize=65536):
    hasher = hashlib.new("md5")
    buffer = afile.read(blocksize)
    while len(buffer) > 0:
        hasher.update(buffer)
        buffer = afile.read(blocksize)
    _hash = hasher.hexdigest()

    return _hash

