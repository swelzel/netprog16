from flask import Flask , request
import hashlib
app = Flask(__name__)

clientHashmap = dict({})
filenames = {"kernel-nvidia":"TinyCore-current.iso",
	"kernel-ati":"TinyCore-current.iso"}
localKernelHash = "myMD5Checksum"

@app.route("/S2C_Alive", methods=['POST', 'GET'])
def alive():
	mac = request.values.get("mac")
	config2hashmap(request.values.get("cpu"), request.values.get("graka"), mac)
	global clientHashmap
	if clientHashmap[mac] == null:
		clientHashmap[mac] = config
	return "the cake is a lie"

def config2hashmap(cpu, graka, mac):
	if(cpu == "x86"):
		if(graka == "nvidia"):
			global clientHashmap[mac] = "kernel-nvidia"
		elif(graka == "ati"):
			global clientHashmap[mac] = "kernel-ati"
	elif(cpu == "x64"):
		if(graka == "nvidia"):
			global clientHashmap[mac] = "kernel-nvidia"
		elif(graka == "ati"):
			global clientHashmap[mac] = "kernel-ati"
		
#die clientseite will selber vergleichen 
@app.route("/S2C_AnswerKernel", methods=['POST', 'GET'])
def av_Kernel():
	mac = request.values.get("mac")
	maHash = request.values.get("hash")
	
	if(maHash == "" || maHash.lenght != 32):
		return false
	else:
		_file = open(global filenames["kernel-nvidia"],"rb")
		lacalKernelHash = hashfile(_file)
		if(maHash != localKernelHash):
			return true
		else:
			return false
	return true

@app.route("/S2C_SendKernel", methods=['POST', 'GET'])
def kernel():
	mac = request.values.get("mac")
	return "http://server.ip/"+filename["kernel-nvidia"]

@app.route("/S2C_AnswerCore", methods=['POST', 'GET'])
def av_Core():
	ans = true
	return ans

@app.route("/S2C_SendCore", methods=['POST', 'GET'])
def core():
	return "test URL"

@app.route("/S2C_AnswerPackage", methods=['POST', 'GET'])
def av_Package():
	return true

@app.route("/S2C_SendPackage", methods=['POST', 'GET'])
def package():
	return "test URL"

def hashfile(afile, hasher=hashlib.md5(), blocksize=65536):
    buffer = afile.read(blocksize)
    while len(buffer) > 0:
        hasher.update(buffer)
        buffer = afile.read(blocksize)
    return hasher.hexdigest()

