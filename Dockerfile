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
#COPY requirements.txt /app/
RUN apt-get install build-essential
RUN pip install --no-cache-dir -r requirements.txt


# Install required packages
RUN apt-get update && \
#    apt-get install -y build-essential && \
    apt-get clean
#    rm -rf /var/lib/apt/lists/*

# Install Python modules


# Set environment variables
ENV GOOGLE_APPLICATION_CREDENTIALS /app/credentials.json
ENV ASSISTANT_API_ENDPOINT embeddedassistant.googleapis.com
ENV ASSISTANT_API_VERSION v1alpha2
ENV ASSISTANT_DEVICE_MODEL_ID your-device-model-id
ENV ASSISTANT_DEVICE_INSTANCE_ID your-device-instance-id
ENV ASSISTANT_LANGUAGE_CODE en-US
ENV TELEGRAM_BOT_TOKEN your-telegram-bot-token-here

# Set up Chatterbot
RUN mkdir -p /app/data && \
    mkdir -p /app/trainers && \
    mkdir -p /app/corpus
COPY ./data /app/data
COPY ./trainers /app/trainers
COPY ./corpus /app/corpus
RUN python -c "from chatterbot.trainers import ChatterBotCorpusTrainer; from chatterbot import ChatBot; chatbot = ChatBot('MyChatBot'); trainer = ChatterBotCorpusTrainer(chatbot); trainer.train('chatterbot.corpus.english')"

# Set up volume for data persistence
VOLUME /app/data

# Expose port 3636
EXPOSE 3636

# Run the application
CMD ["python", "main.py"]

