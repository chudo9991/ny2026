FROM nginx:alpine

# Копируем все файлы в директорию nginx
COPY . /usr/share/nginx/html/

# Настраиваем nginx для работы с WebRTC
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
