FROM nginx:alpine

# Создаем директорию для сертификатов
RUN mkdir -p /etc/nginx/certs

# Копируем все файлы в директорию nginx
COPY *.html *.glb /usr/share/nginx/html/

# Копируем сертификаты если они существуют
COPY certs/ /etc/nginx/certs/

# Создаем конфигурацию nginx с поддержкой SSL
RUN cat > /etc/nginx/conf.d/default.conf << 'EOF'
server {
    listen 80;
    server_name 45.144.30.194;
    root /usr/share/nginx/html;
    index index.html;
    location / {
        try_files $uri $uri/ /index.html;
    }
    location ~* \.(glb|gltf)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}

# Если сертификаты есть, добавляем HTTPS
EOF

# Добавляем HTTPS блок если сертификаты существуют
RUN if [ -f /etc/nginx/certs/cert.pem ] && [ -f /etc/nginx/certs/key.pem ]; then \
    cat >> /etc/nginx/conf.d/default.conf << 'EOF'
server {
    listen 443 ssl http2;
    server_name 45.144.30.194;
    root /usr/share/nginx/html;
    index index.html;
    
    ssl_certificate /etc/nginx/certs/cert.pem;
    ssl_certificate_key /etc/nginx/certs/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    location ~* \.(glb|gltf)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF
fi

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
