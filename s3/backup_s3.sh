#!/bin/bash

# Parámetros
DIRECTORIO=$1
BUCKET=$2

# Validaciones
if [ -z "$DIRECTORIO" ] || [ -z "$BUCKET" ]; then
    echo "Uso: bash backup_s3.sh <directorio> <bucket>"
    exit 1
fi

if [ ! -d "$DIRECTORIO" ]; then
    echo "Error: el directorio '$DIRECTORIO' no existe."
    exit 1
fi

# Variables
FECHA=$(date +%Y%m%d_%H%M%S)
ARCHIVO="backup_$FECHA.tar.gz"
LOG="logs/backup_$FECHA.log"

# Crear carpeta de logs si no existe
mkdir -p logs

# Comprimir
echo "Comprimiendo $DIRECTORIO..." | tee -a $LOG
tar -czf $ARCHIVO $DIRECTORIO 2>> $LOG

if [ $? -ne 0 ]; then
    echo "Error al comprimir." | tee -a $LOG
    exit 1
fi

# Subir a S3
echo "Subiendo $ARCHIVO a s3://$BUCKET..." | tee -a $LOG
aws s3 cp $ARCHIVO s3://$BUCKET/$ARCHIVO 2>> $LOG

if [ $? -ne 0 ]; then
    echo "Error al subir a S3." | tee -a $LOG
    exit 1
fi

echo "Backup completado exitosamente." | tee -a $LOG

# Limpiar archivo local
rm $ARCHIVO
