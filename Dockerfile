# Используем официальный образ PHP с Apache
FROM php:7.4-apache

# Устанавливаем необходимые расширения (на всякий случай, для будущих экспериментов)
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# Копируем файлы сайта
COPY website/ /var/www/html/

# Создаем папку для логов и даем права
RUN mkdir -p /var/www/html/logs && \
    chown -R www-data:www-data /var/www/html/logs && \
    chmod -R 755 /var/www/html/logs

# Включаем mod_rewrite для Apache (может пригодиться позже)
RUN a2enmod rewrite

# Указываем рабочую директорию
WORKDIR /var/www/html