import os
import requests
import telebot
from telebot.types import Message, ReplyKeyboardMarkup, KeyboardButton
from dotenv import load_dotenv
from datetime import datetime, timezone

# Загрузка переменных окружения из .env
load_dotenv()

TELEGRAM_API_KEY = os.getenv("TELEGRAM_API_KEY")
WEATHER_API_KEY = os.getenv("WEATHER_API_KEY")

if not TELEGRAM_API_KEY or not WEATHER_API_KEY:
    raise ValueError("❌ Ошибка: отсутствуют API-ключи.")

bot = telebot.TeleBot(TELEGRAM_API_KEY)
user_data = {}

WEATHER_EMOJIS = {
    "Clear": "☀️ Солнечно",
    "Clouds": "☁️ Облачно",
    "Rain": "🌧️ Дождь",
    "Drizzle": "🌦️ Легкий дождь",
    "Thunderstorm": "⛈️ Гроза",
    "Snow": "❄️ Снег",
    "Mist": "🌫️ Дымка",
    "Fog": "🌫️ Туман",
    "Haze": "🌫️ Легкий туман"
}

WIND_DIRECTIONS = ["⬆️", "↗️", "➡️", "↘️", "⬇️", "↙️", "⬅️", "↖️"]
WIND_DIRECTION_TEXT = ["Северный", "Северо-восточный", "Восточный", "Юго-восточный",
                       "Южный", "Юго-западный", "Западный", "Северо-западный"]

DAYS_MAPPING = {"Сегодня": 0, "Завтра": 1, "3 дня": 3, "5 дней": 5}


class Weather:
    def __init__(self, city, forecast_type):
        self.city = city
        self.forecast_type = forecast_type
        self.lat, self.lon = self.get_coordinates()
        self.data = self.get_weather_data()
        self.city_info = self.get_city_info()

    def get_coordinates(self):
        url = f"http://api.openweathermap.org/geo/1.0/direct?q={self.city}&limit=1&appid={WEATHER_API_KEY}"
        response = requests.get(url)
        if response.status_code == 200 and response.json():
            data = response.json()[0]
            return data["lat"], data["lon"]
        return None, None

    def get_weather_data(self):
        if self.lat is None or self.lon is None:
            return None

        url = (f"https://api.openweathermap.org/data/2.5/weather?lat={self.lat}&lon={self.lon}&units=metric&lang=ru&appid={WEATHER_API_KEY}"
               if self.forecast_type == "Сегодня"
               else f"https://api.openweathermap.org/data/2.5/forecast?lat={self.lat}&lon={self.lon}&units=metric&lang=ru&appid={WEATHER_API_KEY}")

        response = requests.get(url)
        return response.json() if response.status_code == 200 else None

    def get_city_info(self):
        if self.forecast_type == "Сегодня":
            return {
                "name": self.data.get("name", self.city),
                "country": self.data.get("sys", {}).get("country", "-"),
                "sunrise": self.data.get("sys", {}).get("sunrise", 0),
                "sunset": self.data.get("sys", {}).get("sunset", 0)
            }
        elif "city" in self.data:
            return {
                "name": self.data["city"]["name"],
                "country": self.data["city"]["country"],
                "sunrise": self.data["city"]["sunrise"],
                "sunset": self.data["city"]["sunset"]
            }
        return {}

    def format_weather(self):
        if self.data is None:
            return "❌ Не удалось получить данные о погоде."

        if self.forecast_type == "Сегодня":
            return self.format_current_weather()
        else:
            return self.format_forecast_weather()

    def format_current_weather(self):
        city_name = self.city_info.get("name", self.city)
        country = self.city_info.get("country", "-")
        sunrise = datetime.fromtimestamp(self.city_info.get("sunrise", 0), timezone.utc).strftime('%H:%M')
        sunset = datetime.fromtimestamp(self.city_info.get("sunset", 0), timezone.utc).strftime('%H:%M')

        temp = round(self.data["main"]["temp"])
        temp_min = round(self.data["main"].get("temp_min", temp))
        temp_max = round(self.data["main"].get("temp_max", temp))
        humidity = self.data["main"]["humidity"]
        pressure = self.data["main"]["pressure"]
        wind_speed = self.data["wind"]["speed"]
        wind_deg = self.data["wind"]["deg"]
        wind_direction = WIND_DIRECTION_TEXT[(wind_deg // 45) % 8]
        wind_arrow = WIND_DIRECTIONS[(wind_deg // 45) % 8]
        weather_main = self.data["weather"][0]["main"]
        weather_description = WEATHER_EMOJIS.get(weather_main, "🌥 Переменная облачность")

        return (
            f"🌍 Город: {city_name} ({country})\n"
            f"🌅 Восход: {sunrise} | 🌇 Закат: {sunset}\n\n"
            f"📅 Сегодня\n"
            f"🌡 Температура: {temp}°C ({weather_description})\n"
            f"🔻 Мин: {temp_min}°C | 🔺 Макс: {temp_max}°C\n"
            f"💧 Влажность: {humidity}% | 🌡 Давление: {pressure} hPa\n"
            f"💨 Ветер: {wind_speed} м/с {wind_arrow} ({wind_direction})"
        )

    def format_forecast_weather(self):
        city_name = self.city_info.get("name", self.city)
        country = self.city_info.get("country", "-")
        sunrise = datetime.fromtimestamp(self.city_info.get("sunrise", 0), timezone.utc).strftime('%H:%M')
        sunset = datetime.fromtimestamp(self.city_info.get("sunset", 0), timezone.utc).strftime('%H:%M')


        days_count = DAYS_MAPPING.get(self.forecast_type, 1)
        forecasts = {}
        for item in self.data["list"]:
            date = item["dt_txt"].split(" ")[0]
            if date not in forecasts:
                forecasts[date] = item

        forecast_texts = [f"🌍 Город: {city_name} ({country})\n🌅 Восход: {sunrise} | 🌇 Закат: {sunset}\n"]
        for date, item in list(forecasts.items())[:days_count]:
            temp = round(item["main"]["temp"])
            temp_min = round(item["main"].get("temp_min", temp))
            temp_max = round(item["main"].get("temp_max", temp))
            humidity = item["main"]["humidity"]
            pressure = item["main"]["pressure"]
            wind_speed = item["wind"]["speed"]
            wind_deg = item["wind"]["deg"]
            wind_direction = WIND_DIRECTION_TEXT[(wind_deg // 45) % 8]
            wind_arrow = WIND_DIRECTIONS[(wind_deg // 45) % 8]
            weather_main = item["weather"][0]["main"]
            weather_desc = item["weather"][0]["description"].capitalize()
            weather_description = WEATHER_EMOJIS.get(weather_main, "🌥 Переменная облачность")

            forecast_texts.append(
                f"📅 {date}\n"
                f"🌡 Температура: {temp}°C {weather_description} ({weather_desc})\n"
                f"🔻 Мин: {temp_min}°C | 🔺 Макс: {temp_max}°C\n"
                f"💧 Влажность: {humidity}% | 🌡 Давление: {pressure} hPa\n"
                f"💨 Ветер: {wind_speed} м/с {wind_arrow} ({wind_direction})"
            )

        return "\n\n".join(forecast_texts)


@bot.message_handler(commands=['start', 'help'])
def send_welcome(message: Message):
    markup = ReplyKeyboardMarkup(resize_keyboard=True)
    markup.add(KeyboardButton("Сегодня"), KeyboardButton("Завтра"), KeyboardButton("3 дня"), KeyboardButton("5 дней"))
    bot.send_message(message.chat.id, "Привет! Выберите количество дней для прогноза погоды:", reply_markup=markup)


@bot.message_handler(func=lambda message: message.text in DAYS_MAPPING)
def select_days(message: Message):
    user_data[message.chat.id] = {"forecast": message.text}
    bot.send_message(message.chat.id, "Введите название города:")


@bot.message_handler(func=lambda message: message.chat.id in user_data)
def send_weather(message: Message):
    city = message.text.strip()
    forecast_type = user_data[message.chat.id]["forecast"]
    weather = Weather(city, forecast_type).format_weather()
    bot.send_message(message.chat.id, weather)
    del user_data[message.chat.id]


if __name__ == "__main__":
    print("Бот запущен...")
    bot.polling(none_stop=True)
