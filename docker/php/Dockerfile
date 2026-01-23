FROM composer:2.4.2 AS composer

FROM php:8.3-fpm AS base

RUN apt-get update \
    && apt-get install -y \
        zlib1g-dev \
        libzip-dev \
        libicu-dev \
        libpq-dev \
        git \
        unzip \
    && docker-php-ext-install -j"$(nproc)" pdo_pgsql intl zip \
    && pecl install apcu-5.1.22 \
    && docker-php-ext-enable apcu \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /usr/src/app

COPY apps/back/ /usr/src/app/

RUN mkdir -p var/cache var/log \
    && chmod -R a+w var

FROM base AS dev

ENV APP_ENV=dev

RUN chown -R 1000:1000 /usr/src/app
USER 1000:1000

RUN composer install --no-scripts

ENV PATH="/usr/src/app/vendor/bin:/usr/src/app/bin:${PATH}"

CMD ["php-fpm"]

FROM base AS prod

ARG DATABASE_URL
ARG APP_SECRET
ENV APP_ENV=prod

RUN chown -R www-data:www-data /usr/src/app
USER www-data

RUN composer install --no-dev --optimize-autoloader --no-scripts

ENV PATH="/usr/src/app/vendor/bin:/usr/src/app/bin:${PATH}"

CMD ["php-fpm"]