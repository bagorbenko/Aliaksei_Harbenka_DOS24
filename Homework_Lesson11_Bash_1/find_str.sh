#!/bin/bash

# Проверка правильного количества аргументов
if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <искомая_строка> <каталог>"
    exit 1
fi

search_string="$1"
directory="$2"

# Проверка существования каталога
if [ ! -d "$directory" ]; then
    echo "Ошибка: Каталог '$directory' не существует."
    exit 1
fi

# Функция для обработки ошибок доступа к каталогам
function handle_error {
    local error_message="$1"
    local inaccessible_dir=$(echo "$error_message" | awk -F"‘|’" '{print $2}')
    echo "Нет доступа к каталогу: $inaccessible_dir"
}

export -f handle_error

# Поиск файлов и обработка ошибок доступа
find "$directory" -type f 2> >(while read -r line; do handle_error "$line"; done) | while read -r file; do
    # Проверка доступности файла для чтения
    if [ -r "$file" ]; then
        # Поиск искомой строки в файле (игнорируя регистр)
        if grep -qi "$search_string" "$file"; then
            # Получение размера файла
            size=$(stat -c%s "$file")
            # Вывод информации о файле
            echo "Полный путь к файлу: $file"
            echo "Имя файла: $(basename "$file")"
            echo "Размер файла: $size байт"
            echo "-----------------------------"
        fi
    else
        echo "Нет доступа к файлу: $file"
    fi
done
