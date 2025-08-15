# edu-backend.py

from flask import Flask, jsonify, request
import subprocess
import os

# Create the Flask application instance.
app = Flask(__name__)

# Define the directory where shell scripts and log files are stored.
SCRIPT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), '/app')
LOG_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), '/var/logs')

# Ensure the directories exist
os.makedirs(SCRIPT_DIR, exist_ok=True)
os.makedirs(LOG_DIR, exist_ok=True)

@app.route('/')
def home():
    """A simple home page to confirm the server is running."""
    return "Flask server is running! Use /run_script/<script_name> and /check_logs/<log_file_name> endpoints."

@app.route('/run_script/<script_name>', methods=['GET'])
def run_script(script_name):
    """
    Runs a specified shell script from the SCRIPT_DIR.
    The script name is passed as a URL parameter.
    """
    script_path = os.path.join(SCRIPT_DIR, script_name)

    # Security check: Ensure the script path is within the designated directory
    if not os.path.abspath(script_path).startswith(SCRIPT_DIR):
        return jsonify({"error": "Invalid script path."}), 400

    if not os.path.exists(script_path) or not os.path.isfile(script_path):
        return jsonify({"error": f"Script '{script_name}' not found."}), 404

    try:
        # Use subprocess.run to execute the script.
        # `capture_output=True` captures stdout and stderr.
        # `text=True` decodes the output as text.
        # `check=True` will raise a CalledProcessError if the command fails.
        result = subprocess.run(
            ['bash', script_path],
            capture_output=True,
            text=True,
            check=True
        )
        return jsonify({
            "status": "success",
            "script_name": script_name,
            "stdout": result.stdout,
            "stderr": result.stderr
        })
    except subprocess.CalledProcessError as e:
        # Handle errors if the shell script itself returns a non-zero exit code.
        return jsonify({
            "status": "error",
            "script_name": script_name,
            "message": "Script execution failed.",
            "stdout": e.stdout,
            "stderr": e.stderr
        }), 500
    except Exception as e:
        # Catch any other unexpected errors during execution.
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@app.route('/check_logs/<log_file_name>', methods=['GET'])
def check_logs(log_file_name):
    """
    Reads and returns the content of a specified log file from the LOG_DIR.
    The log file name is passed as a URL parameter.
    """
    log_path = os.path.join(LOG_DIR, log_file_name)

    # Security check: Ensure the file path is within the designated directory
    if not os.path.abspath(log_path).startswith(LOG_DIR):
        return jsonify({"error": "Invalid file path."}), 400

    if not os.path.exists(log_path) or not os.path.isfile(log_path):
        return jsonify({"error": f"Log file '{log_file_name}' not found."}), 404

    try:
        with open(log_path, 'r') as f:
            log_content = f.read()
        return jsonify({
            "status": "success",
            "log_file": log_file_name,
            "content": log_content
        })
    except Exception as e:
        # Handle file reading errors.
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

if __name__ == '__main__':
    # You can change the host and port. `debug=True` is great for development.
    app.run(debug=True, host='0.0.0.0', port=5000)
