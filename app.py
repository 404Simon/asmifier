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
    debug_info = request.json.get("debugInfo", False)
    transformed_code, decompiled_code = transform_java_code(java_code, debug_info)  # Placeholder for the transformation function
    return jsonify({'transformed': transformed_code, 'decompiled': decompiled_code})

def transform_java_code(java_code, debug=False):
    classname = re.search(r'class\s+(\w+)', java_code).group(1)
    with open(f'{classname}.java', 'w') as f:
        f.write(java_code)
    if debug:
        subprocess.run(['/bin/bash', 'run.sh', classname, '1'])
    else:
        subprocess.run(['/bin/bash', 'run.sh', classname])
    with open(f'{classname}Dump.java', 'r') as f:
        asmified = f.read()
    with open(f'{classname}JD.java', 'r') as f:
        decompiled = f.read()
    # remove first line
    decompiled = decompiled[decompiled.find('\n') + 1:]
    return asmified, decompiled

if __name__ == '__main__':
    app.run(debug=True)

