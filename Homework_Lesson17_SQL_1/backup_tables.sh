#!/bin/bash


# параметры подключения
DB_USER="root"
DB_PASSWORD=""
DB_NAME="lab_tests"
BACKUP_DIR="/home/hara/test_backups/"
BUCKET_NAME="gs://aliaksei_harbenka"

# создаем директорию для бэкапов, если она не существует
mkdir -p $BACKUP_DIR

# генерируем имя файла с текущей датой
BACKUP_FILE="$BACKUP_DIR/backup_$(date +"lab_test").sql"

# создаем дамп базы данных
mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_FILE

# проверяем успешность создания бэкапа
if [ $? -eq 0 ]; then
    echo "Бэкап базы данных успешно создан: $BACKUP_FILE"
    
    # синхронизируем с GCP Storage
    gsutil rsync -r $BACKUP_DIR $BUCKET_NAME/sql_backups/
    
    if [ $? -eq 0 ]; then
        echo "Бэкап успешно синхронизирован с облачным хранилищем"
    else
        echo "Ошибка при синхронизации с GCP Storage"
    fi
else
    echo "Ошибка при создании бэкапа базы данных"
fi
