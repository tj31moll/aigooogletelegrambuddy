from chatterbot import ChatBot
from chatterbot.trainers import ChatterBotCorpusTrainer
from chatterbot.storage import JsonFileStorageAdapter

chatbot = ChatBot(
    'MyChatBot',
    storage_adapter='chatterbot.storage.JsonFileStorageAdapter',
    database='./data/conversations.json',
    output_format='json'
)

trainer = ChatterBotCorpusTrainer(chatbot)
trainer.train('chatterbot.corpus.english')
