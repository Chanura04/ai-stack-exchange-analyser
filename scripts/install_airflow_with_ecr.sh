# REGION=eu-north-1
# set IMAGE_NAME=my-dags
# set IMAGE_TAG=0.0.1
# set NAMESPACE=airflow
# set RELEASE_NAME=airflow
# export ECR_REGISTRY=195322290700.dkr.ecr.eu-north-1.amazonaws.com
# export ECR_REPO=my-dags-repo

# aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 195322290700.dkr.ecr.eu-north-1.amazonaws.com

# #get the latest image tag from ECR
# export LATEST_IMAGE_TAG=$(aws ecr describe-images --repository-name my-dags-repo --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text --region eu-north-1) 

# docker pull 195322290700.dkr.ecr.eu-north-1.amazonaws.com/my-dags-repo:aws ecr describe-images --repository-name my-dags-repo --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text --region eu-north-1
# kind load docker-image 195322290700.dkr.ecr.eu-north-1.amazonaws.com/my-dags-repo:aws ecr describe-images --repository-name my-dags-repo --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text --region eu-north-1

# kubectl create namespace airflow
# kubectl apply -f k8s/secrets/git-secrets.yaml
# kubectl apply -f k8s/volumes/airflow-logs-pv.yaml 
# kubectl apply -f k8s/volumes/airflow-logs-pvc.yaml
# # Install Airflow using Helm
# helm install airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml --set-string images.airflow.repository="195322290700.dkr.ecr.eu-north-1.amazonaws.com/my-dags-repo" --set-string images.airflow.tag="aws ecr describe-images --repository-name my-dags-repo --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text --region eu-north-1" --debug
# # Port forward the API server
# kubectl port-forward svc/airflow-api-server 8080:8080 --namespace airflow

   


# aws configure

# AWS Access Key ID [None]:  AKIAS26Q5UIGBFH5C7NY
# AWS Secret Access Key [None]:   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
# Default region name [None]:  eu-north-1
# Default output format [None]:  json


# aws sts get-caller-identity

# aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 195322290700.dkr.ecr.eu-north-1.amazonaws.com


# docker pull 195322290700.dkr.ecr.eu-north-1.amazonaws.com/my-dags-repo:0.0.1

# docker run -d -p 8080:8080 --name my-dags 195322290700.dkr.ecr.eu-north-1.amazonaws.com/my-dags-repo:0.0.1


 



# docker run -d -p 8080:8080 --name my-dags-v2 195322290700.dkr.ecr.eu-north-1.amazonaws.com/my-dags-repo:0.0.1 airflow api-server


# docker run -d -p 8080:8080 --name my-dags-v2 195322290700.dkr.ecr.eu-north-1.amazonaws.com/my-dags-repo:0.0.1 airflow api-server
