# Usa la imagen oficial de PHP
FROM php:apache
# Instala la extensión pdo_pgsql de PostgreSQL
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo_pgsql
# Agrega la configuración para habilitar la extensión pgsql al final del archivo php.ini
RUN echo "extension=pgsql.so" >> /usr/local/etc/php/php.ini

# Instala la extensión pgsql de PostgreSQL
RUN docker-php-ext-install pgsql
# Establece el directorio de trabajo dentro del contenedor
WORKDIR /var/www/html

# Copia todo el contenido de la carpeta local al directorio de trabajo en el contenedor
COPY desarrollo/. /var/www/html

# Expone el puerto 80 para que otros contenedores o servicios puedan acceder a la aplicación
EXPOSE 80

# Inicia Apache cuando se ejecute el contenedor
CMD ["apache2ctl", "-D", "FOREGROUND"]