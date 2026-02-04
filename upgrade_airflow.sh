

docker-compose run --rm airflow airflow db check-migrations
docker-compose build --no-cache   












 docker-compose run --rm airflow airflow standalone
 docker-compose run airflow airflow db migrate
   nalyser> airflow db migrate


   docker-compose run airflow airflow create-user --username admin  --firstname Admin   --lastname User --role Admin  --email admin@example.com   --password admin