FROM node:16.20.2-alpine as node

# Build FE first
WORKDIR /app
COPY . .
# Building assets
#RUN mkdir -p /app/resources/assets/images
#COPY resources/assets/images /app/resources/assets/images
RUN node -v
RUN npm install
#RUN npm install bootstrap

#RUN npm install popper.js 
#RUN npm install axios
#RUN npm install vue
#RUN npm install vue-loader
RUN npm run prod
#RUN npm install axios vue vue-loader vue-template-compiler bootstrap popper.js && npm run dev
# Build BE
FROM webdevops/php-nginx:8.3-alpine

# Install Laravel framework system requirements (https://laravel.com/docs/10.x/deployment)
RUN apk add oniguruma-dev postgresql-dev libxml2-dev
# All of this already pre installed.
# Validated by running `docker run --rm webdevops/php-nginx:8.2-alpine php -m`
# RUN docker-php-ext-install \
        # ctype \
        # dom \
        # fileinfo \
        # filter \
        # hash \
        # mbstring \
        # openssl \
        # pcre \
        # pdo \
        # session \
        # tokenizer \
        # json \
        # mbstring \
        # pdo_mysql \
        # pdo_pgsql \
        # xml

# Copy Composer binary from the Composer official Docker image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV WEB_DOCUMENT_ROOT /app/public
ENV APP_ENV production
ENV APP_DEBUG true
ENV LOG_CHANNEL stderr
WORKDIR /app
COPY --from=node /app .
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer install --no-interaction --optimize-autoloader --no-dev

RUN composer self-update
# RUN composer require laravel/breeze --dev
RUN composer require inertiajs/inertia-laravel

ENV DB_CONNECTION=mysql
#ENV DB_HOST=dpg-cosk30821fec73chnkig-a
#ENV DB_HOST=dpg-cqoioqjv2p9s73aqpf90-a.oregon-postgres.render.com
#ENV DB_PORT=5432
#ENV DB_DATABASE=flutter_map
#ENV DB_USERNAME=flutter_map_user
#ENV DB_PASSWORD=PKWdnBfR2vtwNs0hOw537PpzEYBCeTXL

#ENV DB_DATABASE=fc_1xnc
#ENV DB_USERNAME=fc_1xnc_user
#ENV DB_PASSWORD=niwPOemyQ4OnoaOWYAhsORFNWzJqAgTV
RUN php artisan config:clear
RUN php artisan cache:clear
#RUN php artisan key:generate 
#RUN php artisan install:api

#RUN composer require moonshine/moonshine
#RUN php artisan moonshine:install


# RUN php artisan migrate --force
# RUN php artisan migrate --force
RUN chown -R application:application .
