from chatterbot import ChatBot
from chatterbot.trainers import ChatterBotCorpusTrainer
from chatterbot.storage import FileStorageAdapter

chatbot = ChatBot(
    'MyChatBot',
    storage_adapter='chatterbot.storage.FileStorageAdapter',
    database_uri='/app/data/conversations.json',
    output_format='json'
)

trainer = ChatterBotCorpusTrainer(chatbot)
trainer.train('chatterbot.corpus.english')
