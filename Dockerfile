FROM nginx:alpine

# Устанавливаем certbot
RUN apk add --no-cache certbot certbot-nginx python3 py3-pip

# Копируем все файлы в директорию nginx
COPY . /usr/share/nginx/html/

# Копируем конфигурацию nginx
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Создаем директорию для certbot
RUN mkdir -p /var/www/certbot

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
