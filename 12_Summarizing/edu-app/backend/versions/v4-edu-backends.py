from flask import Flask, render_template_string
import threading

# Initialize the Flask application
app = Flask(__name__)

# A simple in-memory dictionary to store request counts for different URLs
# This is not thread-safe for production, but fine for a simple example.
# A lock is used to make updates thread-safe.
request_counts = {}
lock = threading.Lock()

@app.route('/')
def index():
    """
    The main route. This will show the request counts.
    """
    with lock:
        # A simple HTML template to display the counts.
        html_template = """
        <h1>URL Request Counter</h1>
        <p>This page tracks how many times each URL has been requested.</p>
        <p>Try visiting different URLs like /hello, /about, or any other path.</p>
        <h2>Current Request Counts:</h2>
        <ul>
        {% for url, count in request_counts.items() %}
            <li><strong>{{ url }}</strong>: {{ count }} requests</li>
        {% endfor %}
        </ul>
        """
        return render_template_string(html_template, request_counts=request_counts)

@app.before_request
def count_request():
    """
    This function runs before every request to any URL.
    It increments the counter for the requested URL.
    """
    # Get the path of the current request, e.g., '/' or '/hello'.
    requested_url = request.path
    with lock:
        # Increment the count for the URL. If it doesn't exist, set it to 1.
        request_counts[requested_url] = request_counts.get(requested_url, 0) + 1

if __name__ == '__main__':
    # Run the application in debug mode for development.
    # The 'host' and 'port' can be customized.
    app.run(debug=True)
