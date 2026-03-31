# Actividad 2 DevOps

Proyecto de automatización en AWS con enfoque DevOps.

## Descripción

Solución que integra gestión de instancias EC2 con Python (Boto3),
respaldo de archivos en S3 con Bash, y orquestación mediante deploy.sh,
siguiendo buenas prácticas de DevOps.

## Estructura
```
project-devops/
├── ec2/
│   └── gestionar_ec2.py
├── s3/
│   └── backup_s3.sh
├── logs/
├── config/
│   └── config.env
└── README.md
```

## Requisitos

- AWS CLI configurado
- Python 3 + boto3
- Git y GitHub CLI

## Uso

### Gestionar EC2
```bash
python3 ec2/gestionar_ec2.py listar
python3 ec2/gestionar_ec2.py iniciar <instance_id>
python3 ec2/gestionar_ec2.py detener <instance_id>
python3 ec2/gestionar_ec2.py terminar <instance_id>
```

### Backup S3
```bash
bash s3/backup_s3.sh <directorio> <bucket>
```

### Deploy (orquestador)
```bash
./deploy.sh listar
./deploy.sh iniciar <instance_id> <directorio> <bucket>
```

## Flujo Git
```
feature/* → develop → main
```

## Reflexión

**¿Qué ventaja tienen los commits progresivos?**
Permiten rastrear el historial de cambios de forma clara, facilitan
encontrar errores y hacen el desarrollo más ordenado.

**¿Por qué evitar hardcoding?**
Porque cambiar valores no requiere
modificar el código, solo la configuración.

**¿Qué rol cumple deploy.sh?**
Es el orquestador central que integra EC2 y S3 en un solo flujo,
simulando CI/CD real.

**¿Qué ventaja tiene separar config del código?**
Facilita cambiar entornos sin tocar la lógica,
y evita exponer valores sensibles en el código.
