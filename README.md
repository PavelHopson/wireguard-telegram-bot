# WireGuard VPN Telegram Bot

[![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![aiogram](https://img.shields.io/badge/aiogram-2.25-009688?style=flat-square&logo=telegram&logoColor=white)](https://docs.aiogram.dev/)
[![WireGuard](https://img.shields.io/badge/WireGuard-VPN-88171A?style=flat-square&logo=wireguard&logoColor=white)](https://www.wireguard.com/)
[![License: MIT](https://img.shields.io/github/license/PavelHopson/wireguard-telegram-bot?style=flat-square)](LICENSE)

Telegram-бот для автоматической раздачи VPN-конфигов (WireGuard) с поддержкой ПК и мобильных устройств. Позволяет генерировать конфигурации, отправлять QR-коды и управлять VPN прямо из Telegram.

---

## Возможности

- Поддержка iOS, Android, Windows, Linux, macOS
- Управление через Telegram-бота (команды `/start`, `/getvpn`)
- Автоматическая генерация конфигов и ключей через shell-скрипт
- Отправка `.conf` файлов прямо в чат
- Systemd-сервис для автозапуска бота на сервере

---

## Технологический стек

| Технология | Назначение |
|---|---|
| **Python 3** | Основной язык |
| **aiogram 2.x** | Telegram Bot API фреймворк |
| **WireGuard** | VPN-протокол |
| **Bash** | Скрипт генерации клиентских конфигов |
| **systemd** | Автозапуск и управление сервисом |

---

## Быстрый старт

### 1. Подготовка сервера (Ubuntu 22.04+)

```bash
apt update && apt upgrade -y
apt install wireguard qrencode python3 python3-pip git -y
```

### 2. Установка бота

```bash
git clone https://github.com/PavelHopson/wireguard-telegram-bot.git
cd wireguard-telegram-bot
pip3 install -r requirements.txt
```

### 3. Настройка переменных окружения

Скопируйте `.env.example` в `.env` и заполните значения:

```bash
cp .env.example .env
nano .env
```

### 4. Настройка WireGuard

```bash
wg genkey | tee server_private.key | wg pubkey > server_public.key
cp wg0.conf.template /etc/wireguard/wg0.conf
nano /etc/wireguard/wg0.conf
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
```

### 5. Запуск

```bash
python3 bot.py
```

Для автозапуска через systemd:

```bash
cp wg-bot.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable wg-bot
systemctl start wg-bot
```

---

## Как это работает

1. Пользователь отправляет `/start` боту
2. Команда `/getvpn <имя>` генерирует клиентский конфиг
3. Бот вызывает `add_client.sh` для создания ключей и конфигурации
4. Готовый `.conf` файл отправляется пользователю в чат
5. Пользователь импортирует конфиг в приложение WireGuard

---

## Структура проекта

```
wireguard-telegram-bot/
├── bot.py                 # Основной код бота (aiogram)
├── add_client.sh          # Bash-скрипт генерации клиентских конфигов
├── wg0.conf.template      # Шаблон конфигурации WireGuard-сервера
├── wg-bot.service         # Systemd unit-файл для автозапуска
├── requirements.txt       # Python-зависимости
├── .env.example           # Пример переменных окружения
└── LICENSE
```

---

## Лицензия

Проект распространяется под лицензией MIT. Подробнее см. [LICENSE](LICENSE).

## Автор

**Павел Хопсон** — [GitHub](https://github.com/PavelHopson)
