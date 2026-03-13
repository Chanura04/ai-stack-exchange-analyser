# Create or replace a kind cluster
kind delete cluster --name kind
kind create cluster --image kindest/node:v1.29.4

# Add airflow to my Helm repo
helm repo add apache-airflow https://airflow.apache.org
helm repo update
helm show values apache-airflow/airflow > chart/values-example.yaml

# Export values for Airflow docker image
# set IMAGE_TAG=$(date +%Y%m%d%H%M%S)
set IMAGE_NAME=my-dags
set IMAGE_TAG=0.0.1
set NAMESPACE=airflow
set RELEASE_NAME=airflow

# Build the image and load it into kind
docker build --pull --tag my-dags:0.0.1 -f cicd/Dockerfile .
kind load docker-image my-dags:0.0.1

# Create a namespace
kubectl create namespace airflow

# Apply kubernetes secrets
kubectl apply -f k8s/secrets/git-secrets.yaml


kubectl apply -f chart/postgres.yaml
kubectl apply -f chart/airflow-secrets.yaml
kubectl apply -f chart/airflow-db-init.yaml
kubectl apply -f chart/airflow-user.yaml
kubectl apply -f chart/airflow-scheduler.yaml
kubectl apply -f chart/airflow-web.yaml

kubectl exec -it airflow-webserver-6d9784c7c6-nftlv -n airflow -- airflow users create --username admin --firstname Admin  --lastname User  --role Admin  --email admin@example.com --password admin


# Install Airflow using Helm
# helm install airflow apache-airflow/airflow \
#     --namespace airflow -f chart/values-override.yaml \
#     --set-string images.airflow.tag="0.0.1" \
#     --debug

helm install airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml --set-string images.airflow.tag="0.0.1" --debug

# helm install airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml --set images.airflow.repository=my-dags --set images.airflow.tag=0.0.1 --no-hooks --debug


# Port forward the API server
kubectl port-forward svc/airflow-api-server 8080:8080 --namespace airflow


docker build --pull -t my-dags:0.0.1 -f cicd/Dockerfile .


# helm uninstall airflow -n airflow --ignore-not-found   
# kubectl delete namespace airflow --ignore-not-found  
# helm upgrade airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml



#get all pods , deployments , services in airflow namespace
kubectl get all -n airflow
#if there is error 
kubectl logs -n airflow pod/airflow-api-server-7997c49769-6z2hg      -c api-server -f

helm uninstall airflow -n airflow

helm install airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml  --set images.airflow.tag=3.0.2


helm upgrade airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml --debug


kubectl exec -it pod/airflow-api-server-597cdd769c-h27wc -n airflow -- airflow users create  --username admin  --firstname Admin --lastname User role Admin  --email admin@example.com  --password admin


kubectl create secret generic airflow-api-secret-key -n airflow --from-literal=api-secret-key=$(openssl rand -hex 32)

 
     