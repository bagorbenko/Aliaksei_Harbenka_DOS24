#!/bin/bash


#  наличие исходника и нового расширения
if [ $# -ne 2 ]; then
    echo "Usage: $0 name new_ext"
    exit 1
fi


# аргументы
name="$1"
new_ext="$2"


# проверка на наличие расширения в исходнике
if [[ "$name" == *.* ]]; then
    # если расширение есть, заменяем его на новое
    base_name="${name%.*}"
    new_name="${base_name}.${new_ext}"
else
    # если расширения нет, просто добавляем новое расширение
    new_name="${name}.${new_ext}"
fi


# копирование содержимого исходника в новый файл
cp "$name" "$new_name"


# принт имя нового файла
echo "File was renamed to: $new_name"