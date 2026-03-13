from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.http.hooks.http import HttpHook
from datetime import datetime
from produce_data_assets_3 import posts_asset, users_asset


def trigger_databricks_job():
    job_id = "308838823871271"

    # Use Airflow HTTP hook to get connection details
    http_hook = HttpHook(http_conn_id='databricks_conn', method='POST')
    endpoint = "/api/2.1/jobs/run-now"
    json_data = {"job_id": job_id}

    response = http_hook.run(endpoint, json=json_data)
    response.raise_for_status()
    print("Triggered job response:", response.json())

with DAG(dag_id="trigger_databricks_job", start_date=datetime(2023, 1, 1), schedule=(posts_asset & users_asset)) as dag:
    trigger = PythonOperator(
        task_id="trigger_databricks_job",
        python_callable=trigger_databricks_job,
    )   