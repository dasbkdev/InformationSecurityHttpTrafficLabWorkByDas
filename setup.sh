#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Установка учебного полигона HTTP${NC}"
echo -e "${GREEN}================================${NC}"

# Обновляем систему
echo -e "${YELLOW}[1/6] Обновление системы...${NC}"
sudo apt update && sudo apt upgrade -y

# Устанавливаем необходимые пакеты
echo -e "${YELLOW}[2/6] Установка необходимых пакетов...${NC}"
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    git \
    vim \
    net-tools

# Устанавливаем Docker
echo -e "${YELLOW}[3/6] Установка Docker...${NC}"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Добавляем пользователя в группу docker (чтобы не использовать sudo)
echo -e "${YELLOW}[4/6] Настройка прав для Docker...${NC}"
sudo usermod -aG docker $USER

# Устанавливаем Docker Compose (опционально, но может пригодиться)
echo -e "${YELLOW}[5/6] Установка Docker Compose...${NC}"
sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Создаем директорию для проекта и копируем файлы
echo -e "${YELLOW}[6/6] Подготовка проекта...${NC}"
mkdir -p ~/http-traffic-lab

# Копируем файлы из текущей директории (предполагаем что скрипт запускается из папки с проектом)
cp -r . ~/http-traffic-lab/

# Собираем и запускаем Docker контейнер
cd ~/http-traffic-lab
echo -e "${YELLOW}Сборка Docker образа...${NC}"
docker build -t http-lab .

echo -e "${YELLOW}Запуск контейнера...${NC}"
docker run -d \
    --name http-lab-container \
    -p 80:80 \
    -v ~/http-traffic-lab/website/logs:/var/www/html/logs \
    http-lab

# Проверяем результат
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Установка завершена успешно!${NC}"
    echo -e "${GREEN}================================${NC}"
    echo -e "Сайт доступен по адресу: ${YELLOW}http://localhost${NC}"
    echo -e "Логи сохраняются в: ${YELLOW}~/http-traffic-lab/website/logs/access.log${NC}"
    echo -e ""
    echo -e "${RED}ВАЖНО: Для применения прав Docker нужно перезайти в систему${NC}"
    echo -e "${RED}или выполнить: newgrp docker${NC}"
    echo -e "${GREEN}================================${NC}"
else
    echo -e "${RED}❌ Ошибка при установке${NC}"
fi