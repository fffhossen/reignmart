FROM php:8.4-fpm-alpine

# Install system dependencies and PHP extensions
RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    git

RUN docker-php-ext-install pdo pdo_mysql bcmath

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy existing application directory contents
COPY . .

# Install all PHP dependencies
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Setup directory permissions
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expose port and start server
EXPOSE 8080
CMD php artisan serve --host=0.0.0.0 --port=8080