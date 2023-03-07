# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY ./src /app/src
COPY requirements.txt /app

# Install build tools
RUN apt-get update && \
    apt-get install -y build-essential

RUN apt-get update && \
    apt-get install -y gcc python-dev

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that the server will listen on
EXPOSE 8080

# Start the server using CMD
CMD ["python", "src/main.py"]
