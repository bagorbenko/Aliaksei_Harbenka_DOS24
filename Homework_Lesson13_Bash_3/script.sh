#!/bin/bash

# Функция для получения данных о погоде
get_weather_data() {
    CITY_NAME=$1  # Название города (первый параметр)

    # Извлекаем API_KEY из config.env
    API_KEY=$(grep "API_KEY" ../config.env | cut -d '=' -f2)

    # Формируем URL запроса
    URL="http://api.openweathermap.org/data/2.5/weather?q=$CITY_NAME&appid=$API_KEY&units=metric"
    
    # Получаем данные о погоде
    RESPONSE=$(curl -s $URL)

    # Извлекаем информацию из ответа
    TEMP=$(echo $RESPONSE | jq '.main.temp')
    HUMIDITY=$(echo $RESPONSE | jq '.main.humidity')
    WIND_SPEED=$(echo $RESPONSE | jq '.wind.speed')
    DESCRIPTION=$(echo $RESPONSE | jq -r '.weather[0].description')

    # Добавление символа градуса напрямую
    DEGREE_SYMBOL="°"

    # Выводим результаты с символом градуса
    echo "Погода в $CITY_NAME:"
    echo "Температура: $TEMP$DEGREE_SYMBOL C"
    echo "Влажность: $HUMIDITY%"
    echo "Скорость ветра: $WIND_SPEED м/с"
    echo "Описание: $DESCRIPTION"
}

# Вызов функции с переданным городом
get_weather_data $1
