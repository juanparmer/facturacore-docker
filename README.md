# FacturaCore Docker Submodule 🐳

> [!NOTE]
> Este submódulo contiene el entorno de despliegue en contenedores para **Odoo 18.0** con la base de datos PostgreSQL, configurados detrás de un servidor web **Nginx** que actúa como proxy reverso seguro (HTTPS) con renovación automática de certificados SSL mediante **Certbot** (Let's Encrypt).

---

## 📂 Estructura del Submódulo

El submódulo se compone de los siguientes archivos de configuración:

- [docker-compose.yml](file:///c:/Users/jupar/Documents/UNIR/facturacore/docker/docker-compose.yml): Orquestación de servicios (db, web, nginx, certbot).
- [Dockerfile](file:///c:/Users/jupar/Documents/UNIR/facturacore/docker/Dockerfile): Personalización de Odoo para clonar los repositorios e instalar módulos adicionales de forma automatizada.
- [nginx/default.conf](file:///c:/Users/jupar/Documents/UNIR/facturacore/docker/nginx/default.conf): Archivo de configuración para Nginx con redirección HTTP a HTTPS y mapeo de rutas longpolling.

---

## 🚀 Guía de Inicialización de Certificado SSL (Let's Encrypt)

Dado que Nginx no iniciará si el bloque HTTPS está activo y no se encuentran las llaves del certificado, debes seguir este proceso de arranque inicial:

### Paso 1: Configurar tu Dominio
Edita el archivo [nginx/default.conf](file:///c:/Users/jupar/Documents/UNIR/facturacore/docker/nginx/default.conf) y reemplaza todas las instancias de `YOUR_DOMAIN_HERE` con tu dominio real (por ejemplo: `odoo.miempresa.com`).

### Paso 2: Comentar temporalmente la sección HTTPS de Nginx
Abre el archivo [nginx/default.conf](file:///c:/Users/jupar/Documents/UNIR/facturacore/docker/nginx/default.conf) y **comenta todo el segundo bloque `server` (el de la línea `listen 443 ssl`)**. Esto permitirá que Nginx inicie escuchando únicamente por el puerto 80 para pasar el desafío de Certbot.

### Paso 3: Levantar contenedores básicos
Ejecuta el levantamiento de los contenedores:
```bash
docker-compose up -d db web nginx
```

### Paso 4: Solicitar el Certificado SSL a Let's Encrypt
Ejecuta el comando de Certbot para solicitar tu certificado de manera interactiva:
```bash
docker-compose run --rm certbot certonly --webroot --webroot-path=/var/www/certbot --email tu_correo@empresa.com --agree-tos --no-eff-email -d odoo.miempresa.com
```
*(Nota: Reemplaza `odoo.miempresa.com` con tu dominio real).*

### Paso 5: Descomentar la sección HTTPS en Nginx
Vuelve a abrir [nginx/default.conf](file:///c:/Users/jupar/Documents/UNIR/facturacore/docker/nginx/default.conf) y **descomenta el bloque `server` del puerto 443** que comentaste en el Paso 2.

### Paso 6: Reiniciar Nginx y levantar Certbot de fondo
Reinicia Nginx para que cargue la configuración segura y levanta el servicio Certbot para que se encargue de renovar el certificado cada 12 horas de forma automática:
```bash
docker-compose down
docker-compose up -d
```

¡Listo! Odoo ahora estará accesible de manera segura mediante HTTPS.
