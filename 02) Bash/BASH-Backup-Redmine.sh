#!/bin/bash

# Detener el servicio ctlscript
sudo /opt/bitnami/ctlscript.sh stop

# Fecha Actual (Se va usar para el nombre del Backup File)
current_date=$(date +"%Y-%m-%d")

# Backup!
sudo tar -pczvf "/opt/bitnami-redmine-bkp-$current_date.tar.gz" /opt/bitnami

# Copia el backup a artechnas01
sudo cp "/opt/bitnami-redmine-bkp-$current_date.tar.gz" "/mnt/artechnas01/Servers/"

# Elimina el archivo original
sudo rm "/opt/bitnami-redmine-bkp-$current_date.tar.gz"

# Crear un registro
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "Backup realizado el $timestamp" >> "/mnt/artechnas01/Servers/logs/backup.log"

# Correo en caso de error
if [ $? -ne 0 ]; then
    echo "Error al realizar el backup." >> "/mnt/artechnas01/Servers/logs/backup.log"
    echo "Enviando correo de error..."
    echo "Error al realizar el backup de Redmine." | mail -s "[FALLO BACKUP REDMINE DIARIO]" -a "/mnt/artechnas01/Servers/logs/backup.log" soporte@artech-consulting.com
fi