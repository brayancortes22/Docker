# Documentación de errores y soluciones en el despliegue

## Backend

### Error: No se puede conectar a SQL Server
**Mensaje:**  
A network-related or instance-specific error occurred while establishing a connection to SQL Server...

**Causas y solución:**  
- El contenedor backend y SQL Server no estaban en la misma red de Docker.
- La cadena de conexión usaba `localhost` en vez del nombre del servicio (`sqlserver`).
- Solución: Verificamos la red con `docker network inspect`, corregimos la cadena de conexión en `appsettings.json` y aseguramos que ambos contenedores estuvieran en la misma red.

### Error: Migraciones no aplicadas
**Mensaje:**  
No project was found. Change the current working directory or use the --project option.

**Causas y solución:**  
- Se ejecutaba el comando en el directorio incorrecto.
- Solución: Ejecutar `dotnet ef database update --startup-project ../API` desde la carpeta del contexto.

### Verificación de base de datos
**Acción:**  
- Usamos `sqlcmd` para conectarnos al contenedor SQL Server y verificar la existencia de la base de datos y tablas.

---

## Frontend

### Error: Nginx muestra la página de bienvenida
**Mensaje:**  
Welcome to nginx!

**Causas y solución:**  
- El archivo `index.nginx-debian.html` estaba presente en `/var/www/html/`.
- Solución: Renombrar o eliminar ese archivo para que Nginx sirva el `index.html` del frontend.

### Error: Los estilos y scripts no se aplican
**Mensaje:**  
Se bloqueó la carga de un módulo de “http://localhost:8080/assets/index-DsMhjVVo.js” debido a un tipo MIME no permitido (“text/plain”).
La hoja de estilos no se ha cargado porque su tipo MIME, "text/plain", no es "text/css".

**Causas y solución:**  
- Nginx no servía los archivos JS y CSS con el tipo MIME correcto por una mala configuración del bloque `/assets/`.
- Solución:  
  - Agregar el bloque `/assets/` con `alias` y la directiva `types` en `nginx.conf`:
    ```nginx
    location /assets/ {
        alias /var/www/html/assets/;
        try_files $uri =404;
        types {
            text/css css;
            application/javascript js;
        }
    }
    ```
  - Reiniciar Nginx y limpiar la caché del navegador.

---

## Recomendaciones finales

- Verificar siempre la red de Docker y los nombres de los servicios.
- Usar el archivo de configuración correcto en producción.
- Configurar Nginx para servir correctamente los archivos estáticos y los tipos MIME.
- Documentar cada cambio y error para futuras referencias.

# frontend 
Ha fallado la carga del módulo con origen "https://localhost/assets/index-DsMhjVVo.js". app:7:71
Se bloqueó la carga de un módulo de “https://localhost/assets/index-DsMhjVVo.js” debido a un tipo MIME no permitido (“text/html”).

app
Error: An unexpected error occurred spoofer.js:1:38935

​# backend
ya esta lo del backend
