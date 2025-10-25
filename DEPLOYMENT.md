# 🚀 Инструкция по развёртыванию

## Требования

- Сервер с установленными Docker и Docker Compose
- Домен, указывающий на IP вашего сервера
- Порты 80 и 443, открытые в файрволе

## Быстрое развёртывание

### 1. Клонирование проекта

```bash
git clone <your-repo-url>
cd ny2026
```

### 2. Настройка SSL сертификата

```bash
# Сделайте скрипт исполняемым
chmod +x init-letsencrypt.sh

# Запустите инициализацию SSL
DOMAIN=ar-example.com EMAIL=admin@example.com ./init-letsencrypt.sh
```

### 3. Запуск приложения

```bash
# Запуск в фоновом режиме
docker-compose up -d

# Просмотр логов
docker-compose logs -f ar-app
```

Приложение будет доступно по адресу: `https://ar-example.com`

## Ручная настройка без скрипта

Если автоматический скрипт не работает, выполните шаги вручную:

### 1. Создайте директории

```bash
mkdir -p ./certbot/conf ./certbot/www
```

### 2. Запустите nginx без SSL

```bash
docker-compose up -d ar-app
```

### 3. Получите сертификат

```bash
docker-compose exec ar-app certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email your@email.com \
    --agree-tos \
    --no-eff-email \
    -d your-domain.com
```

### 4. Обновите nginx.conf

Замените `YOUR_DOMAIN` на ваш домен в файле `nginx.conf`:

```bash
sed -i 's/YOUR_DOMAIN/your-domain.com/g' nginx.conf
```

### 5. Перезапустите контейнеры

```bash
docker-compose down
docker-compose up -d
```

## Настройка файрвола

### Ubuntu/Debian (ufw)

```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload
```

### CentOS/RHEL (firewalld)

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

## Автоматическое обновление сертификата

Сертификаты обновляются автоматически каждые 12 часов через контейнер `certbot-renew`.

Проверить статус можно:

```bash
docker-compose logs certbot-renew
```

Вручную обновить:

```bash
docker-compose exec ar-app certbot renew
docker-compose exec ar-app nginx -s reload
```

## Проверка SSL

```bash
# Проверить сертификат
openssl s_client -connect your-domain.com:443 -servername your-domain.com

# Онлайн проверка
# Перейдите на: https://www.ssllabs.com/ssltest/
```

## Устранение проблем

### Сертификат не выдается

1. Проверьте, что домен указывает на IP сервера:
```bash
dig your-domain.com
```

2. Проверьте, что порты открыты:
```bash
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443
```

3. Проверьте логи:
```bash
docker-compose logs ar-app
docker-compose logs certbot-renew
```

### Камера не работает в HTTPS

Браузеры требуют HTTPS для доступа к камере на удалённых серверах. Убедитесь, что:
- Используется HTTPS (не HTTP)
- Сертификат валиден
- Нет предупреждений в браузере

### Ошибка "Connection refused"

1. Проверьте статус контейнеров:
```bash
docker-compose ps
```

2. Перезапустите контейнеры:
```bash
docker-compose restart
```

## Откат к HTTP

Если нужно временно отключить SSL:

1. Измените `docker-compose.yml`:
```yaml
ports:
  - "9000:80"  # Вместо 80:80
```

2. Удалите volumes и environment из конфигурации

3. Перезапустите:
```bash
docker-compose down
docker-compose up -d --build
```

## Мониторинг

### Просмотр логов в реальном времени

```bash
docker-compose logs -f
```

### Проверка статуса контейнеров

```bash
docker-compose ps
```

### Использование ресурсов

```bash
docker stats
```

## Резервное копирование

Сертификаты хранятся в `./certbot/conf`. Сделайте резервную копию:

```bash
tar -czf certbot-backup.tar.gz ./certbot/conf
```

Восстановление:

```bash
tar -xzf certbot-backup.tar.gz
```
