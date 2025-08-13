# Dockerfile
# Use a base Python image
FROM python:3.9-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .
COPY sources.list /etc/apt/

# Add packages
#RUN apt update && apt install -y --no-install-recommends curl 

# Add log file
RUN echo "app: backend" > /etc/backend.conf

# Expose the port your Flask app will run on
EXPOSE 5000

# Define the command to run your Flask application
CMD ["python", "kube-backend.py"]
