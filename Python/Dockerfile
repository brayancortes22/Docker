FROM ubuntu:22.04 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv git nginx mariadb-server mariadb-client supervisor pkg-config libmariadb-dev curl wget inotify-tools && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    # Instalar .NET SDK 9.0 y ASP.NET Core Runtime
    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-9.0 aspnetcore-runtime-9.0 && \
    # Instalar dotnet-ef
    dotnet tool install --global dotnet-ef && \
    rm -rf /var/lib/apt/lists/*

# Configuración de supervisord
RUN mkdir -p /etc/supervisor/conf.d


# Clonar los repositorios en /app/back y /app/front
RUN mkdir -p /app && \
    git clone https://github.com/July173/Back-endProyecto.git /app/back && \
    git clone https://github.com/July173/Front-end-Proyecto-2025.git /app/front || true

# Instalar dependencias y preparar backend Django
WORKDIR /app/back
RUN python3 -m venv venv
RUN /bin/bash -c 'source venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt'

# Instalar dependencias y compilar frontend React
WORKDIR /app/front
RUN npm install || true
RUN npm run build || true


# Copiar el build de React a la carpeta pública de Nginx (soporta build/ o dist/)
RUN mkdir -p /var/www/html
RUN cp -r /app/front/build/* /var/www/html/ 2>/dev/null || true
RUN cp -r /app/front/dist/* /var/www/html/ 2>/dev/null || true
# Asegurar permisos correctos para Nginx
RUN chmod -R 755 /var/www/html && chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /app/back/static && chown -R www-data:www-data /app/back/static
RUN chmod -R 755 /app/front && chown -R www-data:www-data /app/front


# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf


# Copiar configuración de supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copiar script de inicialización
COPY init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Copiar script de auto-refresh (se encargará de hacer git pull y reiniciar Django)
COPY git_autorefresh.sh /usr/local/bin/git_autorefresh.sh
RUN chmod +x /usr/local/bin/git_autorefresh.sh


# Instalar .NET SDK 9.0 y herramientas relacionadas
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-9.0 aspnetcore-runtime-9.0


# Exponer puerto de Nginx
EXPOSE 8080

# Comando de inicio: inicializar y luego supervisor controla MariaDB + Nginx + Django
CMD ["/bin/bash", "-c", "/usr/local/bin/init.sh && /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf"]
