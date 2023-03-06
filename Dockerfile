# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster
# Build stage
#FROM python:3.9-alpine AS build

RUN apk add --no-cache gcc musl-dev

WORKDIR /app

COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt


# Final stage
FROM python:3.9-alpine AS final

WORKDIR /app

COPY --from=build /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
COPY . /app

ENV GOOGLE_APPLICATION_CREDENTIALS /app/credentials.json
ENV ASSISTANT_API_ENDPOINT $ASSISTANT_API_ENDPOINT
ENV ASSISTANT_API_VERSION $ASSISTANT_API_VERSION
ENV ASSISTANT_DEVICE_MODEL_ID $ASSISTANT_DEVICE_MODEL_ID
ENV ASSISTANT_DEVICE_INSTANCE_ID $ASSISTANT_DEVICE_INSTANCE_ID
ENV ASSISTANT_LANGUAGE_CODE $ASSISTANT_LANGUAGE_CODE
ENV TELEGRAM_BOT_TOKEN $TELEGRAM_BOT_TOKEN

RUN mkdir -p /app/data && \
    mkdir -p /app/trainers && \
    mkdir -p /app/corpus
COPY ./data /app/data
COPY ./trainers /app/trainers
COPY ./corpus /app/corpus
RUN python -c "from chatterbot.trainers import ChatterBotCorpusTrainer; from chatterbot import ChatBot; chatbot = ChatBot('MyChatBot'); trainer = ChatterBotCorpusTrainer(chatbot); trainer.train('chatterbot.corpus.english')"

VOLUME /app/data

EXPOSE 3636

CMD ["python", "main.py"]

