from flask import Flask , request
app = Flask(__name__)

@app.route("/alive", methods=['POST', 'GET'])
def alive():
	return "I am alive"
	
@app.route("/update_av_Kernel", methods=['POST', 'GET'])
def av_Kernel():
	ans = true
	return ans

@app.route("/update_Kernel", methods=['POST', 'GET'])
def kernel():
	return "test URL"

@app.route("/update_av_Core", methods=['POST', 'GET'])
def av_Core():
	ans = true
	return ans

@app.route("/update_Core", methods=['POST', 'GET'])
def core():
	return "test URL"

@app.route("/update_av_Package", methods=['POST', 'GET'])
def av_Package():
	return true

@app.route("/update_Package", methods=['POST', 'GET'])
def package():
	return "test URL"

# curl --noproxy 127.0.0.1 -x POST -d "zahlen=1,2,3" http://127.0.0.1:5000/r/sum

#curl  --noproxy 127.0.0.1 "http://127.0.0.1:5000/r/sum?zahlen=1,2,3,4"

