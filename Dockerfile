FROM apache/airflow:2.6.2

USER root

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER airflow

# Clonar el repositorio de DAGs en un directorio temporal
RUN git clone https://github.com/smars1/Airflow_dags_testing.git /tmp/repo && \
    mv /tmp/repo/dags/* /opt/airflow/dags/ && \
    rm -rf /tmp/repo

COPY requirements.txt /requirements.txt

RUN pip install --upgrade pip
RUN pip install -r /requirements.txt

# Configurar Airflow para usar SQLite (que es el valor predeterminado)
ENV AIRFLOW__CORE__EXECUTOR=SequentialExecutor
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False
ENV AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=sqlite:////opt/airflow/airflow.db
ENV AIRFLOW__CORE__FERNET_KEY=${FERNET_KEY}
ENV AIRFLOW__DAG_DEFAULT_VIEW=graph

# Inicializar la base de datos y luego iniciar el webserver y scheduler
CMD ["bash", "-c", "airflow db init && airflow webserver & airflow scheduler"]

