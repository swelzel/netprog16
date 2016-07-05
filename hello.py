from flask import Flask, request
app = Flask(__name__)

@app.route('/') 
def hello_world():
    return 'Hallo Welt!'

@app.route('/calc', methods=['GET', 'POST'])
def calc():
    if request.values.get('op') == 'add':
        no1 = float(request.values.get('no1'))
        no2 = float(request.values.get('no2'))
        erg = no1 + no2
        return str(erg)
    elif request.values.get('op') == 'sub':
        no1 = float(request.values.get('no1'))
        no2 = float(request.values.get('no2'))
        erg = no1 - no2
        return str(erg)
    elif request.values.get('op') == 'mult':
        no1 = float(request.values.get('no1'))
        no2 = float(request.values.get('no2'))
        erg = no1 * no2
        return str(erg)
    elif request.values.get('op') == 'div':
        no1 = float(request.values.get('no1'))
        no2 = float(request.values.get('no2'))
        erg = no1 / no2
        return str(erg)
    elif request.values.get('op') == 'sum':
        numbers =  request.values.get('numbers').strip().split(',')
        erg = 0.0
        for number in numbers:
            erg = erg + float(number)
        return str(erg)
    else:
        return 'Irgendwas dummes ist passiert'
    
