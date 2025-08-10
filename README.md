# WireGuard VPN Telegram Bot

Телеграм-бот для автоматической раздачи VPN-конфигов (WireGuard) с поддержкой ПК и смартфонов. Позволяет добавлять пользователей, генерировать QR-коды и управлять VPN прямо из Telegram.

---

## 🚀 Возможности

- 📱 Поддержка iOS, Android, Windows, Linux, macOS.
- 🤖 Управление через Telegram-бота.
- 🔑 Автоматическая генерация конфигов и ключей.
- 🖼 Отправка QR-кодов для удобного подключения.
- 👥 Управление списком пользователей.
- 💰 Возможность интеграции с платёжными системами для подписок.

---

## 🛠 Установка на сервер

### 1. 📡 Аренда VPS

Выберите VPS с Ubuntu 22.04, минимальные характеристики: **1 CPU, 512 MB RAM, 10 GB SSD**. Рекомендуемые провайдеры: Selectel, Timeweb Cloud, Hetzner.

### 2. 🔑 Подготовка сервера

```bash
ssh root@SERVER_IP
apt update && apt upgrade -y
apt install wireguard qrencode python3 python3-pip git -y
```

### 3. 🤖 Установка бота

```bash
git clone https://github.com/YOUR_USERNAME/wireguard-telegram-bot.git
cd wireguard-telegram-bot
pip3 install -r requirements.txt
```

### 4. ⚙ Настройка переменных окружения

Создайте файл `.env`:

```env
BOT_TOKEN=ВАШ_ТОКЕН_ТЕЛЕГРАМ_БОТА
SERVER_PUBLIC_IP=IP_СЕРВЕРА
WG_INTERFACE=wg0
```

### 5. 🖧 Настройка WireGuard

```bash
wg genkey | tee server_private.key | wg pubkey > server_public.key
cp wg0.conf.template /etc/wireguard/wg0.conf
nano /etc/wireguard/wg0.conf
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
```

### 6. 🔄 Запуск бота

```bash
python3 bot.py
```

Для автозапуска:

```bash
cp wg-bot.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable wg-bot
systemctl start wg-bot
```

---

## 📲 Как работает VPN

1. Пользователь отправляет `/start` в боте.
2. Администратор вводит команду `/add username`.
3. Бот генерирует конфиг и QR-код.
4. Пользователь импортирует данные в приложение WireGuard.
5. VPN готов к использованию.

---

## 🎨 Дизайн и кастомизация

- Поддержка брендированных логотипов в QR-кодах.
- Цветовая схема под ваш проект.
- Возможность интеграции панели управления.

---

## 💡 Примечания

- Поддержка платёжных систем: ЮMoney, криптовалюта, Stripe.
- При необходимости можно заменить WireGuard на V2Ray или OpenVPN.

