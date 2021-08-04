# set base image (host OS)
FROM php:7.3-cli

# install php dependencies
RUN apt-get update -y && apt-get install -y libmcrypt-dev libonig-dev zip git

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install pdo mbstring pdo_mysql

# set the working directory in the container
WORKDIR /app

# copy the dependencies file to the working directory
COPY . ./
# install dependencies
RUN composer install

# copy the src
# COPY . ./

RUN echo "#!/bin/sh\nsleep 2\ncd /app\necho artisan migrate\nphp artisan migrate:fresh --seed\necho artisan serve\nphp artisan serve --host=0.0.0.0 --port=80" > "/tmp/run.sh"
RUN chmod a+x "/tmp/run.sh"

# expose container port
EXPOSE 80
# command to run on container start
# CMD "php artisan serve --host=0.0.0.0 --port=80"
ENTRYPOINT ["/tmp/run.sh"]
