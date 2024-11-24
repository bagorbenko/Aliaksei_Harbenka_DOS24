#!/bin/bash


new_file="$1"
directory="$2"
extension="$3"

# Проверка пути каталога
if [ ! -d "$directory" ]; then
    echo "Ошибка: Каталога '$directory' нет. Проверьте правильность пути."
    exit 1
fi

# Поиск файлов (глубина падения 3)
find "$directory" -maxdepth 3 -type f -name "*.$extension" > "$new_file"

echo "Имена файлов с расширением '$extension' записаны в '$new_file'."

