#!/bin/bash

# Iniciar MariaDB
service mariadb start

# Esperar a que MariaDB esté listo
sleep 10

# Configurar usuario root con contraseña
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
FLUSH PRIVILEGES;
EOF

# Crear base de datos
mysql -u root -p123456 <<EOF
CREATE DATABASE IF NOT EXISTS dbautogestion CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EOF

# Detener MariaDB temporalmente (supervisord lo iniciará)
service mariadb stop

# Hacer migraciones de Django
cd /app/back
source venv/bin/activate
python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic --noinput

echo "Inicialización completa"</content>
<parameter name="filePath">c:\Users\bscl\Downloads\Docker\Python\init.sh
