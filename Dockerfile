FROM odoo:18.0

USER root

# Instalamos git para poder clonar los repositorios
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Creamos el directorio para tus módulos personalizados
RUN mkdir -p /mnt/extra-addons

# Clonamos tus repositorios directamente dentro de la imagen de Docker
RUN git clone -b 18.0 https://github.com/juanparmer/facturacore-connector.git /mnt/extra-addons/facturacore-connector
RUN git clone -b 18.0 https://github.com/oca/web.git /mnt/extra-addons/web

# Devolvemos los permisos al usuario odoo
RUN chown -R odoo:odoo /mnt/extra-addons

USER odoo