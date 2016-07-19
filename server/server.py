from flask import Flask , request
import hashlib
app = Flask(__name__)

global clientHashmap
clientHashmap = dict({})
global filenames
filenames = {"kernel-nvidia":"TinyCore-current.iso",
	"kernel-ati":"TinyCore-current.iso"}

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
	mac = request.values.get("mac")
	maHash = request.values.get("hash")
	
	if(maHash is None):
		return "False"
	else:
		_file = open("core.gz","rb")
		return hashfile(_file)

@app.route("/S2C_SendKernel", methods=['POST', 'GET'])
def kernel():
	mac = request.values.get("mac")
	return "http://server.ip/"+filename["kernel-nvidia"]

@app.route("/S2C_AnswerCore", methods=['POST', 'GET'])
def av_Core():
	ans = "True"
	return ans

@app.route("/S2C_SendCore", methods=['POST', 'GET'])
def core():
	return "test URL"

@app.route("/S2C_AnswerPackage", methods=['POST', 'GET'])
def av_Package():
	return "True"

@app.route("/S2C_SendPackage", methods=['POST', 'GET'])
def package():
	return "test URL"

def hashfile(afile, hasher=hashlib.md5(), blocksize=65536):
    buffer = afile.read(blocksize)
    while len(buffer) > 0:
        hasher.update(buffer)
        buffer = afile.read(blocksize)
    _hash = hasher.hexdigest()
    return _hash

