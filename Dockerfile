#This is a simple configuration with no aws stuff added to entrypoint
FROM php:7.4-apache
RUN docker-php-ext-install mysqli
COPY html/ /var/www/html/
EXPOSE 80
