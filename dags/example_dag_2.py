import time
import datetime
from airflow.sdk import DAG, task

with DAG(
    dag_id="example_dag_2",
    start_date=datetime.datetime(2021, 1, 1),
    schedule="@daily"
):
    
    @task
    def hello_world():
        time.sleep(5)
        print("Hello world, from Airflow_2!")
    
    @task
    def goodbye_world():
        time.sleep(5)
        print("Goodbye world, from Airflow_2!")
    
    hello_world() >> goodbye_world()
