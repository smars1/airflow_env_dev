FROM apache/airflow:2.6.2

# Instalar las dependencias del sistema necesarias para compilar psycopg2 y git (opcional, ya que SQLite no lo requiere)
USER root

RUN apt-get update && apt-get install -y \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cambiar a usuario airflow
USER airflow

# Clonar el repositorio de DAGs en un directorio temporal
RUN git clone https://github.com/smars1/Airflow_dags_testing.git /tmp/repo && \
    mv /tmp/repo/dags/* /opt/airflow/dags/ && \
    rm -rf /tmp/repo

# Copiar el archivo de requerimientos
COPY requirements.txt /requirements.txt

# Instalar las dependencias de Python
RUN pip install --upgrade pip
RUN pip install -r /requirements.txt

# Configurar Airflow para usar SQLite (que es el valor predeterminado)
ENV AIRFLOW__CORE__EXECUTOR=SequentialExecutor
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False
ENV AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=sqlite:////opt/airflow/airflow.db
ENV AIRFLOW__CORE__FERNET_KEY=${FERNET_KEY}
ENV AIRFLOW__DAG_DEFAULT_VIEW=graph

# Comando para iniciar Airflow
CMD ["airflow", "webserver"]
