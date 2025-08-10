wireguard-telegram-bot — Репозиторий для MVP

Что внутри (кратко)
add_client.sh — скрипт генерации клиента (ключи, добавление peer в /etc/wireguard/wg0.conf, генерация /root/<name>.conf).
bot.py — простой aiogram-бот, принимает /getvpn <name> и отсылает файл с конфига. Запускается как сервис systemd.
wg0.conf.template — шаблон серверного конфига (с PLACEHOLDER для приватного ключа сервера).
wg-bot.service — unit для systemd для автозапуска бота.
requirements.txt — зависимости Python.
README.md — эта инструкция (в репозитории также).

# WireGuard Telegram Bot — Быстрый старт

## Описание
Минимальный комплект для запуска WireGuard VPN и Telegram-бота, выдающего клиентские конфиги.

**Важное замечание:** НИКОГДА не публикуй приватные ключи в открытом репозитории.

## Быстрая инструкция
1. Клонируй репозиторий на сервер:
   ```bash
   git clone <this-repo-url>
   cd wireguard-telegram-bot
2. Подготовка сервера (Ubuntu/Debian):
    apt update && apt upgrade -y
    apt install wireguard iptables python3-pip -y
3. Сгенерируй ключи сервера:
    wg genkey | tee /etc/wireguard/server_private.key | wg pubkey > /etc/wireguard/server_public.key
    chmod 600 /etc/wireguard/server_private.key
4. Отредактируй /etc/wireguard/wg0.conf — используй файл wg0.conf.template как образец. Замените PRIVATE_KEY_SERVER 
на содержимое /etc/wireguard/server_private.key.
5. Сделай исполняемым скрипт генерации и протестируй вручную:
    chmod +x add_client.sh
    ./add_client.sh testuser
    # После этого появится /root/testuser.conf
6. Создай бота в Telegram (BotFather) и вставь токен в bot.py (или оставь PLACEHOLDER и экспортируй в ENV).
7. Установи зависимости и запусти бота:
    pip3 install -r requirements.txt
    python3 bot.py
8. Сделай systemd-сервис (файл wg-bot.service) и включи автозапуск:
    cp wg-bot.service /etc/systemd/system/wg-bot.service
    systemctl daemon-reload
    systemctl enable wg-bot
    systemctl start wg-bot
