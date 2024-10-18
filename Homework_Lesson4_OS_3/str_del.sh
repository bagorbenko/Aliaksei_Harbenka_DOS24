#!/bin/bash


if [ "$#" -lt 3 ]; then
    echo "Usage: $0 string start_position end_position [delete]"
    exit 1
fi


# вводные аргументы
string="$1"
start="$2"
end="$3"
del="$4"


# выделяем подстроку
if [ "$del" == "del" ]; then
    # удалить подстроку
    prefix=$(echo "$string" | cut -c1-$((start-1)))
    suffix=$(echo "$string" | cut -c$((end+1))-)
    new_string="${prefix}${suffix}"
else
    # выделить подстроку
    new_string=$(echo "$string" | cut -c"${start}"-"${end}")
fi


echo "Result: $new_string"
