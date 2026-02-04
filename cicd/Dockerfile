FROM apache/airflow:3.1.7-python3.13

USER root
COPY ../requirements.txt /requirements.txt
RUN chown airflow: /requirements.txt

USER airflow
RUN pip install --no-cache-dir -r /requirements.txt

COPY ../dags /opt/airflow/dags

