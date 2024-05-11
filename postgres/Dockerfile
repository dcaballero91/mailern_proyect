# Usa la imagen oficial de PostgreSQL
FROM postgres:latest

# Copia el archivo de respaldo de la base de datos al directorio /docker-entrypoint-initdb.d/ en el contenedor
# Esto asegurará que el archivo se ejecute automáticamente durante el inicio del contenedor
COPY backupBD.sql /docker-entrypoint-initdb.d/

# Establece las variables de entorno para configurar las credenciales predeterminadas del usuario postgres
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD 123

# Expone el puerto 5432 para que otros contenedores o servicios puedan acceder a PostgreSQL
EXPOSE 5432