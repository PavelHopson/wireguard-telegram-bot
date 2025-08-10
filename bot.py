import os
import subprocess
from aiogram import Bot, Dispatcher, types
from aiogram.utils import executor

# Замените PLACEHOLDER_BOT_TOKEN на ваш токен или экспортируйте в ENV
TOKEN = os.getenv('WG_BOT_TOKEN', 'PLACEHOLDER_BOT_TOKEN')
bot = Bot(token=TOKEN)
dp = Dispatcher(bot)

@dp.message_handler(commands=['start'])
async def cmd_start(message: types.Message):
    await message.reply("Привет! Я бот. Используй /getvpn <имя> чтобы получить конфиг WireGuard.")

@dp.message_handler(commands=['getvpn'])
async def cmd_getvpn(message: types.Message):
    parts = message.text.split()
    if len(parts) != 2:
        await message.reply("Использование: /getvpn <имя>")
        return
    name = parts[1]
    # Запускаем скрипт генерации конфига
    proc = subprocess.run(["/root/add_client.sh", name], capture_output=True, text=True)
    if proc.returncode != 0:
        await message.reply(f"Ошибка при создании конфига:\n{proc.stderr}")
        return
    path = f"/root/{name}.conf"
    if not os.path.exists(path):
        await message.reply("Файл не найден после генерации.")
        return
    # Отправляем файл
    await message.answer_document(types.InputFile(path))

if __name__ == '__main__':
    executor.start_polling(dp)