

docker-compose run --rm airflow airflow db check-migrations
docker-compose build --no-cache   



pge_url= https://eu-north-1.console.aws.amazon.com/ecr/repositories/private/195322290700/my-dags-repo/_/details?region=eu-north-1
---for run the docker image from ECR repository---
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 195322290700.dkr.ecr.eu-north-1.amazonaws.com
docker pull 195322290700.dkr.ecr.eu-north-1.amazonaws.com/my-dags-repo:0.0.1
docker run 195322290700.dkr.ecr.eu-north-1.amazonaws.com/my-dags-repo:0.0.1
docker run -p 8080:8080 -it 195322290700.dkr.ecr.eu-north-1.amazonaws.com/my-dags-repo:0.0.1 airflow api-server





 docker-compose run --rm airflow airflow standalone
 docker-compose run airflow airflow db migrate
   nalyser> airflow db migrate


   docker-compose run airflow airflow create-user --username admin  --firstname Admin   --lastname User --role Admin  --email admin@example.com   --password admin