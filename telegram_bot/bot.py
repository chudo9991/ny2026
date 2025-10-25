#!/usr/bin/env python3
"""
Telegram бот для новогоднего AR приложения
"""

import os
import logging
from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup, WebAppInfo
from telegram.ext import Application, CommandHandler, MessageHandler, filters, ContextTypes

# Настройка логирования
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# Получаем переменные окружения
BOT_TOKEN = os.getenv('BOT_TOKEN')
BOT_USERNAME = os.getenv('BOT_USERNAME', 'simple_test_clvb2_bot')
WEBAPP_URL = os.getenv('WEBAPP_URL', 'https://45.144.30.194:9443/')

# Новогоднее поздравление
NEW_YEAR_GREETING = """
🎄🎅🎉 **С НОВЫМ ГОДОМ!** 🎉🎅🎄

Дорогие друзья! 

Пусть этот новый год принесет вам:
✨ Много радости и счастья
🌟 Исполнение всех желаний  
🎁 Новые возможности и успехи
💫 Здоровье, любовь и благополучие

А пока предлагаем вам окунуться в мир новогоднего волшебства с нашей AR-елкой! 

Нажмите кнопку ниже, чтобы запустить интерактивное приложение! 🎄✨
"""

async def start_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Обработчик команды /start"""
    keyboard = [
        [InlineKeyboardButton(
            "🎄 Запустить AR-елку", 
            web_app=WebAppInfo(url=WEBAPP_URL)
        )]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    
    await update.message.reply_text(
        NEW_YEAR_GREETING,
        parse_mode='Markdown',
        reply_markup=reply_markup
    )

async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Обработчик всех остальных сообщений"""
    keyboard = [
        [InlineKeyboardButton(
            "🎄 Открыть AR-приложение", 
            web_app=WebAppInfo(url=WEBAPP_URL)
        )]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    
    await update.message.reply_text(
        "🎄 Хотите увидеть новогоднюю елку в дополненной реальности?\n\n"
        "Нажмите кнопку ниже!",
        reply_markup=reply_markup
    )

async def error_handler(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Обработчик ошибок"""
    logger.error(f"Update {update} caused error {context.error}")

def main() -> None:
    """Основная функция запуска бота"""
    
    # Проверяем наличие токена
    if not BOT_TOKEN:
        logger.error("BOT_TOKEN не найден в переменных окружения!")
        return
    
    # Создаем приложение
    application = Application.builder().token(BOT_TOKEN).build()
    
    # Добавляем обработчики
    application.add_handler(CommandHandler("start", start_command))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    
    # Добавляем обработчик ошибок
    application.add_error_handler(error_handler)
    
    # Запускаем бота
    logger.info(f"Запуск бота @{BOT_USERNAME}")
    logger.info(f"WebApp URL: {WEBAPP_URL}")
    
    application.run_polling(allowed_updates=Update.ALL_TYPES)

if __name__ == '__main__':
    main()
