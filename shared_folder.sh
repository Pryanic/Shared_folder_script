#!/bin/bash

echo "Обновление пакетов и установка зависимостей..."
sudo apt update
sudo apt install -y build-essential dkms linux-headers-$(uname -r)

echo "Установка дополнений гостевой ОС..."
if [ -d /media/cdrom ]; then
    cd /media/cdrom
    sudo ./VBoxLinuxAdditions.run
else
    echo "Ошибка: Не удалось найти смонтированный ISO с дополнениями гостевой ОС."
    exit 1
fi

echo "Создание директории для монтирования общей папки..."
sudo mkdir -p /mnt/shared

SHARED_FOLDER_NAME="s21" 
echo "Монтирование общей папки $SHARED_FOLDER_NAME..."
sudo mount -t vboxsf $SHARED_FOLDER_NAME /mnt/shared

echo "Добавление записи в /etc/fstab для автоматического монтирования..."
echo "$SHARED_FOLDER_NAME /mnt/shared vboxsf defaults 0 0" | sudo tee -a /etc/fstab

CURRENT_USER=$(whoami)
echo "Добавление пользователя $CURRENT_USER в группу vboxsf..."
sudo usermod -aG vboxsf $CURRENT_USER

echo "Настройка завершена. Общая папка должна быть доступна в /mnt
