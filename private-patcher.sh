#!/bin/bash
set -e

# Параметры
FILEID="194mcZlyw3nxzRDY_g-trbqbss0vrmt0v"
ARCHIVE="patch.tar.gz"
TMPDIR=$(mktemp -d)

echo "Скачивание архива..."
# Получаем confirm-токен (если требуется) и скачиваем архив
CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://drive.google.com/uc?export=download&id=${FILEID}" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p')
wget --load-cookies /tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILEID}" -O "$ARCHIVE"
rm -f /tmp/cookies.txt

echo "Распаковка архива..."
tar -xzvf "$ARCHIVE" -C "$TMPDIR"

echo "Создание необходимых директорий..."
sudo mkdir -p /usr/lib/openvpn/bot/handlers
sudo mkdir -p /usr/lib/openvpn/functions

echo "Замена файлов..."
sudo cp -f "$TMPDIR/base.py" /usr/lib/openvpn/bot/handlers/base.py
sudo cp -f "$TMPDIR/create_key.py" /usr/lib/openvpn/bot/handlers/create_key.py
sudo cp -f "$TMPDIR/send_file_to_mail.py" /usr/lib/openvpn/bot/handlers/send_file_to_mail.py
sudo cp -f "$TMPDIR/other.py" /usr/lib/openvpn/functions/other.py
sudo cp -f "$TMPDIR/main.py" /usr/lib/openvpn/main.py
sudo cp -f "$TMPDIR/domains.txt" /usr/lib/openvpn/domains.txt

echo "Очистка временных файлов..."
rm -rf "$TMPDIR" "$ARCHIVE"

echo "Готово!
