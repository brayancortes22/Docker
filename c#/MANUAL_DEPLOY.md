# Manual de despliegue: Backend C# + Frontend React en Docker con Nginx y HTTPS

## Requisitos previos
- Docker instalado en tu sistema (Windows, Linux o Mac)
- Acceso a los repositorios:
  - Backend: https://github.com/Mari2303/Experiencia-Significativa-Backend-.git
  - Frontend: https://github.com/Mari2303/Experiencias-Significativas-Front.git

## Pasos para construir y ejecutar el contenedor

1. **Clona este repositorio o descarga los archivos Docker (`Dockerfile`, `nginx.conf`, `supervisord.conf`)**

2. **Construye la imagen Docker:**

```powershell
# Desde la carpeta donde está el Dockerfile
docker build -t miapp-back-front .
```

3. **Ejecuta el contenedor exponiendo los puertos 8080 (HTTP) y 443 (HTTPS):**

```powershell
docker run -d -p 8080:8080 --name contenedor-back-front miapp-back-front
```

4. **Accede desde tu navegador:**
- Frontend: https://localhost/app
- Backend: https://localhost/api

> Nota: El navegador mostrará una advertencia de seguridad por el certificado autofirmado. Puedes aceptarlo para desarrollo local.

## ¿Qué hace el contenedor?
- Instala dependencias necesarias (.NET, Node.js, Nginx, Supervisor, Git)
- Clona los repositorios de backend y frontend
- Compila y publica el backend C#
- Compila el frontend React y lo copia a Nginx
- Genera certificados SSL autofirmados
- Configura Nginx para exponer `/app` y `/api` por HTTPS
- Inicia automáticamente Nginx y el backend C# al arrancar

## Personalización
- Puedes modificar las rutas en `nginx.conf` para cambiar las URLs expuestas.
- Para usar certificados reales, reemplaza los archivos en `/etc/nginx/ssl/`.

## Configuración de base de datos
El contenedor instala y configura automáticamente tres motores de base de datos para que puedas usar el que prefieras en tu backend:

- **SQL Server** (usuario: `sa`, contraseña: `Sqlserver123$`)
- **MariaDB/MySQL** (usuario: `root`, contraseña: `123456`)
- **PostgreSQL** (usuario: `root`, contraseña: `123456`)

Para conectar tu backend, usa la cadena de conexión correspondiente en el archivo `appsettings.json`:

**SQL Server**
```json
"DefaultConnection": "Server=localhost,1433;Database=backend;User Id=sa;Password=Sqlserver123$;TrustServerCertificate=True"
```

**dentro del contenedor de miapp-back-front**

```
cd /app/backend/Entity
dotnet ef database update --startup-project ../API

```


**MariaDB/MySQL**
```json
"DefaultConnection": "Server=localhost;Database=backend;User=root;Password=123456;"
```

**PostgreSQL**
```json
"DefaultConnection": "Host=localhost;Database=backend;Username=root;Password=123456"
```

Selecciona el motor y la cadena según el provider que uses en tu backend. Así puedes probar y desarrollar con el motor que prefieras sin cambiar el entorno.

## Inicialización manual de MariaDB (si usas MariaDB dentro del contenedor principal)

1. Accede al contenedor:
  ```sh
  docker exec -it <nombre_del_contenedor_app> bash
  ```
2. Inicia el servicio MariaDB:
  ```sh
  service mariadb start
  ```
3. Accede a MariaDB como root:
  ```sh
  mysql -u root -p
  # Si no tiene contraseña, usa: mysql -u root --password=''
  ```
4. Ejecuta los comandos SQL:
  ```sql
  CREATE DATABASE backend CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
  GRANT ALL PRIVILEGES ON backend.* TO 'root'@'localhost';
  FLUSH PRIVILEGES;
  ```

### Recomendación
Para producción, usa el contenedor oficial de MariaDB en docker-compose y configura la base de datos y usuario con variables de entorno:

```yaml
services:
  mariadb:
   image: mariadb:latest
   environment:
    MYSQL_ROOT_PASSWORD: 123456
    MYSQL_DATABASE: backend
```
Así la base de datos y el usuario se crean automáticamente al iniciar el contenedor.

## Solución de problemas
- Si el contenedor no inicia, revisa los logs con:
  ```powershell
  docker logs contenedor-back-front
  ```
- Si el frontend o backend no carga, verifica la configuración de los puertos y las rutas en `nginx.conf`.

## Detalles técnicos
- El backend C# corre en Kestrel (puerto 5000 dentro del contenedor).
- El frontend React se sirve como archivos estáticos por Nginx.
- Nginx redirige HTTP (8080) a HTTPS (443).

---

Cualquier duda, consulta este manual o revisa los archivos de configuración incluidos.
