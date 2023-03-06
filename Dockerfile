# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

# Set the working directory to /app
WORKDIR /app

# Install gcc and python3-pip
RUN apt-get update && apt-get install -y \
    gcc \
    python3-pip

# Copy the current directory contents into the container at /app
COPY . /app

# Install the required Python packages
RUN apt-get install build-essential
RUN pip install --no-cache-dir -r requirements.txt

# Set the command to run the Python script
CMD ["python", "my_bot.py"]
