FROM mcr.microsoft.com/dotnet/sdk:9.0 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y nginx mariadb-server mariadb-client supervisor && \
    rm -rf /var/lib/apt/lists/*

# Configuración de supervisord
RUN mkdir -p /etc/supervisor/conf.d

# Copiar archivos web
COPY html/ /var/www/html/

# Copiar configuración de Nginx
COPY default /etc/nginx/sites-available/default

# Copiar configuración de supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Exponer puerto de Nginx
EXPOSE 8080

# Comando de inicio: supervisor controla MariaDB + Nginx
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
