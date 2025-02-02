import csv

def calculate_mean_from_large_csv(file_path, column_index):
    total = 0
    count = 0
    with open(file_path, mode='r', encoding='utf-8') as file:
        reader = csv.reader(file)
        next(reader)  # пропуск заголовок, на всякий
        for row in reader:
            try:
                total += float(row[column_index])
                count += 1
            except (ValueError, IndexError):
                continue  # добавим случай некорректной строки, чтобы не стопиться
    return total / count if count else 0

# Пример использования
file_path = './large_test_data.csv'
column_index = 2  
mean_value = calculate_mean_from_large_csv(file_path, column_index)
print(f"Среднее значение: {mean_value}")
