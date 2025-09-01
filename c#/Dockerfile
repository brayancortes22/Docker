FROM ubuntu:22.04 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Instalar dependencias, Node.js 18.x, MariaDB y PostgreSQL
RUN apt-get update && \
    apt-get install -y git nginx supervisor curl wget pkg-config gnupg2 mariadb-server mariadb-client postgresql postgresql-contrib && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-9.0 aspnetcore-runtime-9.0 && \
    rm -rf /var/lib/apt/lists/*

# Instalar dotnet-ef
RUN dotnet tool install --global dotnet-ef
ENV PATH="$PATH:/root/.dotnet/tools"
# instalar el sqlclient para mirar bd de sql server
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools
ENV PATH="$PATH:/opt/mssql-tools/bin:$PATH"

# Crear base de datos y usuario en MariaDB y PostgreSQL



# Generar certificados SSL autofirmados
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx-selfsigned.key \
    -out /etc/nginx/ssl/nginx-selfsigned.crt \
    -subj "/C=CL/ST=Santiago/L=Santiago/O=MiEmpresa/OU=IT/CN=localhost"

# Configuración de supervisord
RUN mkdir -p /etc/supervisor/conf.d

# Clonar los repositorios de backend y frontend
WORKDIR /app
RUN git clone https://github.com/Mari2303/Experiencia-Significativa-Backend-.git backend
RUN git clone https://github.com/Mari2303/Experiencias-Significativas-Front.git frontend

# Compilar backend C#
WORKDIR /app/backend
RUN dotnet restore
RUN dotnet build --configuration Release
RUN dotnet publish API/API.csproj -c Release -o /app/publish

# Compilar frontend React
WORKDIR /app/frontend
RUN npm install
RUN npm run build

# Copiar el build de React a la carpeta pública de Nginx
RUN cp -r dist/* /var/www/html/
RUN chmod -R 755 /var/www/html && chown -R www-data:www-data /var/www/html

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar configuración de supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Exponer puerto de Nginx
EXPOSE 8080

# Comando de inicio: supervisor controla Nginx + Backend C#
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]


