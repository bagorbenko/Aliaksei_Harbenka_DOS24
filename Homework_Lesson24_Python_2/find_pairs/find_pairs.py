import random


def find_pairs(arr, tar_num):
    my_set = set() #множество для хранения 
    pairs = [] #пустой список пар
    for a in arr:
        b = tar_num - a
        if b in my_set:
            pairs.append((a, b)) #для удобства будем добавлять кортежи
        my_set.add(a)
    return pairs


arr = [random.randint(1, 10**6) for i in range(10**6)]
tar_sum = int(input("Введите целевую сумму: "))
filtered_numbers = [num for num in arr if num < tar_sum]
print("Список всех чисел массива, которые меньше суммы:", filtered_numbers)
count_of_pairs = input("Введите количество пар (или 'все' для вывода всех): ")

result = find_pairs(arr, tar_sum)
total_pairs = len(result)  #общее количество найденных пар

if total_pairs == 0:
    print("Нет найденных пар.")
else:
    if count_of_pairs.lower() == "все":
        print(f"Найдено {total_pairs} пар. Выводим все:")
        print(result)  #выводим все пары
    else:
        count_of_pairs = int(count_of_pairs)  #преобразуем ввод в число
        print(f"Найдено {total_pairs} пар. Отображаем {min(count_of_pairs, total_pairs)}:")
        print(result[:count_of_pairs])  #выводим указанное количество пар