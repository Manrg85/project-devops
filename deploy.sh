#!/bin/bash

# Cargar configuración
source config/config.env

# Parámetros
ACCION=$1
INSTANCE_ID=$2
DIRECTORIO=$3
BUCKET=$4

# Log
FECHA=$(date +%Y%m%d_%H%M%S)
LOG="logs/deploy_$FECHA.log"
mkdir -p logs

echo "=== Deploy iniciado: $FECHA ===" | tee -a $LOG

# Validación de parámetros
if [ -z "$ACCION" ]; then
    echo "Uso: ./deploy.sh [listar|iniciar|detener|terminar] [instance_id] [directorio] [bucket]" | tee -a $LOG
    exit 1
fi

# Ejecutar script EC2
echo "Ejecutando acción EC2: $ACCION" | tee -a $LOG
python3 ec2/gestionar_ec2.py $ACCION $INSTANCE_ID 2>> $LOG

if [ $? -ne 0 ]; then
    echo "Error en script EC2." | tee -a $LOG
    exit 1
fi

# Ejecutar backup S3 si se proporcionó directorio y bucket
if [ ! -z "$DIRECTORIO" ] && [ ! -z "$BUCKET" ]; then
    echo "Ejecutando backup S3..." | tee -a $LOG
    bash s3/backup_s3.sh $DIRECTORIO $BUCKET 2>> $LOG

    if [ $? -ne 0 ]; then
        echo "Error en script S3." | tee -a $LOG
        exit 1
    fi
fi

echo "=== Deploy finalizado exitosamente ===" | tee -a $LOG
