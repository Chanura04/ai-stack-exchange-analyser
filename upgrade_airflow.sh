# Export values for Airflow docker image
export IMAGE_NAME=my-dags
export IMAGE_TAG=$(date +%Y%m%d%H%M%S)
export NAMESPACE=airflow
export RELEASE_NAME=airflow

# Build the image and load it into kind
# docker build --pull --tag $IMAGE_NAME:$IMAGE_TAG -f cicd/Dockerfile .
# kind load docker-image $IMAGE_NAME:$IMAGE_TAG
docker build --pull --tag my-dags:0.0.1 -f cicd/Dockerfile .
kind load docker-image my-dags:0.0.1

# Upgrade Airflow using Helm
# helm upgrade airflow apache-airflow/airflow \
#     --namespace airflow -f chart/values-override.yaml \
#     --set-string images.airflow.tag="$IMAGE_TAG" \
#     --debug
# kubectl create namespace airflow


# helm install airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml --set-string images.airflow.tag="0.0.2" --debug


helm upgrade airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml --set-string images.airflow.tag="0.0.1" --debug


# Port forward the API server
kubectl port-forward svc/airflow-api-server 8080:8080 --namespace airflow


#get all pods , deployments , services in airflow namespace
# kubectl get all -n airflow
# kubectl exec -n airflow pod/airflow-dag-processor-6b79c559f7-twd5c -c dag-processor -- ls -la /opt/airflow/dags/.worktrees/f14c85361c001d5a08b94a58fa8e072626eaf344/dags


# # for update the git credentials 
# kubectl apply -f k8s/secrets/git-secrets.yaml -n airflow




# #refresh
#  kubectl rollout restart deployment/airflow-dag-processor -n airflow
#  kubectl rollout status deployment/airflow-dag-processor -n airflow --timeout=120s