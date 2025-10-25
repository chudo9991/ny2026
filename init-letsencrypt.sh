#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Инициализация SSL/TLS сертификата ===${NC}\n"

# Проверка переменных окружения
if [ -z "$DOMAIN" ]; then
    echo -e "${RED}Ошибка: DOMAIN не установлен${NC}"
    echo "Используйте: DOMAIN=example.com ./init-letsencrypt.sh"
    exit 1
fi

if [ -z "$EMAIL" ]; then
    echo -e "${RED}Ошибка: EMAIL не установлен${NC}"
    echo "Используйте: EMAIL=your@email.com DOMAIN=example.com ./init-letsencrypt.sh"
    exit 1
fi

echo -e "${GREEN}Домен:${NC} $DOMAIN"
echo -e "${GREEN}Email:${NC} $EMAIL\n"

# Создаем директории для certbot
echo -e "${YELLOW}Создание директорий...${NC}"
mkdir -p ./certbot/conf ./certbot/www

# Останавливаем существующие контейнеры
echo -e "${YELLOW}Остановка существующих контейнеров...${NC}"
docker-compose down

# Запускаем nginx без SSL для получения сертификата
echo -e "${YELLOW}Запуск nginx для получения сертификата...${NC}"
docker-compose up -d ar-app

# Ждем запуска nginx
echo -e "${YELLOW}Ожидание запуска nginx...${NC}"
sleep 5

# Получаем сертификат
echo -e "${YELLOW}Получение сертификата от Let's Encrypt...${NC}"
docker-compose exec ar-app certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email "$EMAIL" \
    --agree-tos \
    --no-eff-email \
    -d "$DOMAIN"

# Обновляем nginx.conf с реальным доменом
echo -e "${YELLOW}Обновление конфигурации nginx...${NC}"
sed -i "s/YOUR_DOMAIN/$DOMAIN/g" nginx.conf

# Перезапускаем контейнеры
echo -e "${YELLOW}Перезапуск контейнеров с SSL...${NC}"
docker-compose down
docker-compose up -d

echo -e "\n${GREEN}=== Готово! ===${NC}"
echo -e "${GREEN}Приложение доступно по адресу: https://$DOMAIN${NC}"
echo -e "${GREEN}HTTP редиректится на HTTPS${NC}\n"
