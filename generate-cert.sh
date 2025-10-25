#!/bin/bash

mkdir -p certs

# Генерируем приватный ключ
openssl genrsa -out certs/key.pem 2048

# Генерируем самоподписанный сертификат (валиден 10 лет)
openssl req -new -x509 -key certs/key.pem -out certs/cert.pem -days 3650 -subj "/C=RU/ST=Moscow/L=Moscow/O=AR-App/CN=45.144.30.194"

echo "SSL сертификаты созданы в директории certs/"
ls -lh certs/
