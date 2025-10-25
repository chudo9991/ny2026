# Telegram Bot для AR Новогодней Елки

Telegram бот для запуска AR приложения с новогодней елкой.

## Функции

1. **Команда /start** - выводит новогоднее поздравление с кнопкой для запуска AR приложения
2. **Любое сообщение** - выводит кнопку для открытия webapp
3. **WebApp интеграция** - кнопка открывает AR приложение по адресу https://45.144.30.194:9443/

## Настройка

1. Скопируйте `env.example` в `.env`:
```bash
cp env.example .env
```

2. Заполните переменные в `.env`:
```env
BOT_TOKEN=your_actual_bot_token
BOT_USERNAME=your_bot_username
WEBAPP_URL=https://45.144.30.194:9443/
```

## Запуск

### С Docker Compose (рекомендуется)
```bash
docker-compose up -d
```

### С Docker
```bash
docker build -t ny2026-telegram-bot .
docker run -d --name telegram-bot --env-file .env ny2026-telegram-bot
```

### Локально
```bash
pip install -r requirements.txt
python bot.py
```

## Структура проекта

```
telegram_bot/
├── Dockerfile          # Docker образ
├── docker-compose.yml  # Docker Compose конфигурация
├── bot.py             # Основной код бота
├── requirements.txt   # Python зависимости
├── env.example       # Пример переменных окружения
└── README.md         # Документация
```

## Переменные окружения

- `BOT_TOKEN` - токен бота от @BotFather
- `BOT_USERNAME` - имя бота (опционально)
- `WEBAPP_URL` - URL AR приложения (по умолчанию: https://45.144.30.194:9443/)

## Логи

Логи сохраняются в папку `./logs/` при запуске через Docker Compose.
