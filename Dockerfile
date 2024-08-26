FROM apache/airflow:2.6.2

USER root

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiar y configurar permisos para el script de inicialización
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER airflow

# Clonar el repositorio de DAGs en un directorio temporal
RUN git clone https://github.com/smars1/Airflow_dags_testing.git /tmp/repo && \
    mv /tmp/repo/dags/* /opt/airflow/dags/ && \
    rm -rf /tmp/repo

COPY requirements.txt /requirements.txt
# variables_test.json  debe estar en el mismo directorio que tu Dockerfile
COPY variables_test.json /opt/airflow/variables_test.json


RUN pip install --upgrade pip
RUN pip install -r /requirements.txt


# # Inicializar la base de datos y luego iniciar el webserver y scheduler
CMD ["bash", "-c", "airflow db init && airflow webserver"]

# Usar el script como punto de entrada
ENTRYPOINT ["/entrypoint.sh"]
