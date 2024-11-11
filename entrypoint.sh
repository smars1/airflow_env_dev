#!/bin/bash

# Inicializar la base de datos de Airflow
airflow db init

# Crear el usuario administrador
airflow users create \
    --username "$AIRFLOW_ADMIN_USER" \
    --firstname "$AIRFLOW_ADMIN_FIRSTNAME" \
    --lastname "$AIRFLOW_ADMIN_LASTNAME" \
    --role Admin \
    --email "$AIRFLOW_ADMIN_EMAIL" \
    --password "$AIRFLOW_ADMIN_PASSWORD"

# Iniciar el webserver en segundo plano
airflow webserver &

# Iniciar el scheduler en primer plano
exec airflow scheduler
# Iniciar el webserver de Airflow
#exec airflow webserver
