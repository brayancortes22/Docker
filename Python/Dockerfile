FROM ubuntu:22.04 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv git nginx mariadb-server mariadb-client supervisor pkg-config libmariadb-dev curl wget && \
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


# Clonar el repositorio con backend y frontend
RUN git clone https://github.com/brayancortes22/docker_prueba_Codigo_back_front.git /app

# Instalar dependencias y preparar backend Django
WORKDIR /app/Back-EndProyectoFinal2025
RUN python3 -m venv venv
RUN /bin/bash -c 'source venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt'

# Instalar dependencias y compilar frontend React
WORKDIR /app/Front-end-Proyecto-2025
RUN npm install
RUN npm run build


# Copiar el build de React a la carpeta pública de Nginx
RUN cp -r dist/* /var/www/html/
# Asegurar permisos correctos para Nginx
RUN chmod -R 755 /var/www/html && chown -R www-data:www-data /var/www/html


# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf


# Copiar configuración de supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


# Instalar .NET SDK 9.0 y herramientas relacionadas
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-9.0 aspnetcore-runtime-9.0


# Exponer puerto de Nginx
EXPOSE 8080

# Comando de inicio: supervisor controla MariaDB + Nginx + Django
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
