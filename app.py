from flask import Flask, render_template, request, jsonify
import subprocess
import re

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/transform', methods=['POST'])
def transform_code():
    java_code = request.json['code']
    transformed_code = transform_java_code(java_code)  # Placeholder for the transformation function
    return jsonify({'transformed': transformed_code})

def transform_java_code(java_code):
    classname = re.search(r'class\s+(\w+)', java_code).group(1)
    with open(f'{classname}.java', 'w') as f:
        f.write(java_code)
    output = subprocess.run(['./run.sh', classname], stderr=subprocess.PIPE)
    if output.returncode != 0:
        print(output.stderr.decode())
    with open(f'{classname}Dump.java', 'r') as f:
        java_code = f.read()
    return java_code

if __name__ == '__main__':
    app.run(debug=True)

