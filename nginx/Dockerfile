FROM nginx:alpine

# Копируем конфигурацию
COPY nginx.conf /etc/nginx/nginx.conf

# Создаем папку для SSL сертификатов
RUN mkdir -p /etc/nginx/ssl

# Создаем самоподписанный сертификат (временный)
RUN apk add --no-cache openssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/key.pem \
    -out /etc/nginx/ssl/cert.pem \
    -subj "/C=RU/ST=Moscow/L=Moscow/O=MoreTech/OU=IT/CN=moretech2025clvb.ru"

# Открываем порты
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
