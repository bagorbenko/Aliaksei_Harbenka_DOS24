import telebot
from openai import OpenAI

# Укажите ваш API-ключ Telegram-бота
TELEGRAM_BOT_TOKEN = "7758893586:AAG_N0cHExLc6JZ2hL72fSFO02VDc-jG-yA"

# Инициализация бота
bot = telebot.TeleBot(TELEGRAM_BOT_TOKEN)

# Инициализация клиента OpenAI
client = OpenAI(
    base_url="https://integrate.api.nvidia.com/v1",
    api_key="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"
)

@bot.message_handler(commands=['start'])
def send_welcome(message):
    bot.reply_to(message, "Привет! Я AI-бот созаднный на основе ДипСик Алексеем Горбенко. Задавайте мне вопросы, и я постараюсь ответить.")

@bot.message_handler(func=lambda message: True)
def chat_ai(message):
    try:
        completion = client.chat.completions.create(
            model="deepseek-ai/deepseek-r1",
            messages=[{"role": "user", "content": message.text}],
            temperature=0.6,
            top_p=0.7,
            max_tokens=4096,
            stream=True
        )
        
        response_text = ""
        for chunk in completion:
            if chunk.choices[0].delta.content is not None:
                response_text += chunk.choices[0].delta.content
        
        bot.reply_to(message, response_text)
    except Exception as e:
        bot.reply_to(message, f"Ошибка: {str(e)}")

# Запуск бота
bot.polling(none_stop=True)
