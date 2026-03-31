import boto3
import sys

def get_client():
    return boto3.client('ec2')

def listar_instancias():
    ec2 = get_client()
    response = ec2.describe_instances()
    instancias = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instancias.append({
                'id': instance['InstanceId'],
                'estado': instance['State']['Name'],
                'tipo': instance['InstanceType']
            })
    if not instancias:
        print("No hay instancias disponibles.")
    else:
        for i in instancias:
            print(f"ID: {i['id']} | Estado: {i['estado']} | Tipo: {i['tipo']}")

def iniciar_instancia(instance_id):
    ec2 = get_client()
    ec2.start_instances(InstanceIds=[instance_id])
    print(f"Instancia {instance_id} iniciada.")

def detener_instancia(instance_id):
    ec2 = get_client()
    ec2.stop_instances(InstanceIds=[instance_id])
    print(f"Instancia {instance_id} detenida.")

def terminar_instancia(instance_id):
    ec2 = get_client()
    ec2.terminate_instances(InstanceIds=[instance_id])
    print(f"Instancia {instance_id} terminada.")

def main():
    if len(sys.argv) < 2:
        print("Uso: python3 gestionar_ec2.py [listar|iniciar|detener|terminar] [instance_id]")
        sys.exit(1)

    accion = sys.argv[1]

    if accion == "listar":
        listar_instancias()
    elif accion in ["iniciar", "detener", "terminar"]:
        if len(sys.argv) < 3:
            print(f"Error: debes proporcionar un instance_id para '{accion}'")
            sys.exit(1)
        instance_id = sys.argv[2]
        if accion == "iniciar":
            iniciar_instancia(instance_id)
        elif accion == "detener":
            detener_instancia(instance_id)
        elif accion == "terminar":
            terminar_instancia(instance_id)
    else:
        print(f"Acción desconocida: {accion}")
        sys.exit(1)

if __name__ == "__main__":
    main()
