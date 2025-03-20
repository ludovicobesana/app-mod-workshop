# Use PHP 5.6 with Apache as the base image
FROM php:5.6-apache

# Set the working directory
WORKDIR /var/www/html

# Install required PHP extensions
RUN docker-php-ext-install -j "$(nproc)" \
    opcache \
    mysqli \
    pdo \
    pdo_mysql && \
    docker-php-ext-enable opcache pdo_mysql

# Configure PHP settings for Cloud Run
RUN set -ex; \
    { \
        echo "memory_limit = -1"; \
        echo "max_execution_time = 0"; \
        echo "upload_max_filesize = 32M"; \
        echo "post_max_size = 32M"; \
        echo "opcache.enable = On"; \
        echo "opcache.validate_timestamps = Off"; \
        echo "opcache.memory_consumption = 32"; \
    } > "$PHP_INI_DIR/conf.d/cloud-run.ini"

# Copy application files to container
COPY . .

# Ensure Apache listens on the Cloud Run assigned port (default is 8080)
ENV PORT=8080
ENV DB_HOST=localhost
ENV DB_NAME=image_catalog
ENV DB_USER=appmod-phpapp-user
ENV DB_PASS=wrong_password
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/Listen 80/Listen ${PORT}/" /etc/apache2/ports.conf && \
    sed -i "s/<VirtualHost \*:80>/<VirtualHost \*:${PORT}>/" /etc/apache2/sites-available/000-default.conf

# Set permissions for the uploads directory
RUN chmod -R 777 /var/www/html/uploads

# Expose the port for Cloud Run
EXPOSE 8080

# Start Apache in the foreground
CMD ["apache2-foreground"]