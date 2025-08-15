# Used in the K8s course as a backend for exercises
#

import time
import logging
import os.path
import subprocess

from flask import Flask

logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)

@app.route("/")
def hello():
    file_path = '/var/log/backend.log'
    if os.path.exists(file_path):
        with open(file_path) as data:
            return data.read()
    else:
        return f"File not found: {file_path}"

@app.route("/")
def run_script():
    try:
        # Run the script and wait for it to complete.
        # It's important to pass the command as a list for security.
        subprocess.run(['/app/counter.sh'], check=True)
        return "Script executed successfully!"
    except subprocess.CalledProcessError as e:
        return f"Script failed with an error: {e}"
    except FileNotFoundError:
        return "Error: Script file not found."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

