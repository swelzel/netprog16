from flask import Flask , request
app = Flask(__name__)
localKernelHash = "myMD5Checksum"
@app.route("/S2C_Alive", methods=['POST', 'GET'])
def alive():
	return "I am alive"
#die clientseite will selber vergleichen 
@app.route("/S2C_AnswerKernel", methods=['POST', 'GET'])
def av_Kernel():
	return localKernelHash
#	global localKernelHash
#	maHash=request.values.get("hash")
#	if(maHash=="" || maHash.lenght != 32):
#		return false
#	else:
#		if(maHash != localKernelHash):
#			return true
#		else:
#			return false
#	return true

@app.route("/S2C_SendKernel", methods=['POST', 'GET'])
def kernel():
	return "test URL"

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

# curl --noproxy 127.0.0.1 -x POST -d "zahlen=1,2,3" http://127.0.0.1:5000/r/sum

#curl  --noproxy 127.0.0.1 "http://127.0.0.1:5000/r/sum?zahlen=1,2,3,4"

