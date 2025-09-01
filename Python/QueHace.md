# ¿Qué hace este programa?

Este proyecto crea una imagen Docker que integra un servidor web Nginx y una base de datos MariaDB, gestionados por Supervisor. A continuación se explica cada componente y su función:

## Componentes principales

- **Dockerfile:**  
  Define los pasos para construir la imagen. Instala Nginx, MariaDB y Supervisor, copia los archivos web y las configuraciones necesarias, expone el puerto 8080 y configura el inicio de los servicios mediante Supervisor.

- **index.html:**  
  Es la página web principal que Nginx sirve cuando accedes a `http://localhost:8080`.

- **default (configuración de Nginx):**  
  Configura Nginx para escuchar en el puerto 8080 y servir archivos desde `/var/www/html`, usando `index.html` como página principal.

- **supervisord.conf:**  
  Configura Supervisor para iniciar y mantener activos los servicios de Nginx y MariaDB dentro del contenedor.

- **Comandos Docker (ver `readme`):**  
  Permiten construir la imagen y ejecutar el contenedor, exponiendo el puerto 8080 para acceder a la web.

## ¿Qué hace al ejecutarse?

1. **Construcción:**  
   Al construir la imagen, se instalan y configuran Nginx y MariaDB, y se copian los archivos necesarios.

2. **Ejecución:**  
   Al ejecutar el contenedor, Supervisor inicia Nginx y MariaDB. Nginx sirve la página web en el puerto 8080 y MariaDB queda disponible como base de datos.

3. **Acceso:**  
   Puedes acceder a