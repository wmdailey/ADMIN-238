# Dockerfile
# Use a base Python image
FROM python:3.9-slim-buster

# Copy sources list
COPY sources.list /etc/apt/sources.list

# Set the working directory in the container
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY  app .
RUN chmod +x /app/counter.sh

# Create log file
#RUN echo "URL request: 0" > /var/log/backend.log

# Expose the port your Flask app will run on
EXPOSE 5000

# Define the command to run your Flask application
CMD ["/bin/bash", "-c", "/app/counter.sh" && "python", "edu-backend.py"]
