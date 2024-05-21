FROM php:8.3.6-fpm-alpine

# Set working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apk add --no-cache $PHPIZE_DEPS linux-headers \
    # Install dependencies for GD extension (ensure all necessary image types are supported)
    && apk add --no-cache libpng libpng-dev libjpeg-turbo libjpeg-turbo-dev freetype freetype-dev \
    # Install dependencies for zip extension
    && apk add --no-cache libzip-dev \
    # Install OpenJDK (example with OpenJDK 11)
    && apk add --no-cache openjdk11 \
    # Install xdebug
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    # Install GD extension
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    # Install zip extension
    && docker-php-ext-install zip \
    # Install SOAP extension
    && apk add --no-cache libxml2-dev \
    && docker-php-ext-install soap \
    # Install other PHP extensions
    && docker-php-ext-install pdo pdo_mysql pcntl

# Copy Composer from official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
