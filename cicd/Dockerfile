# FROM apache/airflow:3.0.2-python3.11

# COPY ./dags/ /opt/airflow/dags/

# COPY ./requirements.txt .

# RUN pip install --no-cache-dir -r requirements.txt
FROM apache/airflow:2.10.4-python3.11

COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir -r /requirements.txt