# Export values for Airflow docker image
export IMAGE_NAME=my-dags
export IMAGE_TAG=$(date +%Y%m%d%H%M%S)
export NAMESPACE=airflow
export RELEASE_NAME=airflow


docker build --pull --tag my-dags:0.0.1 -f cicd/Dockerfile .
kind load docker-image my-dags:0.0.1


kubectl apply -f k8s/secrets/git-secrets.yaml
kubectl apply -f k8s/volumes/airflow-logs-pv.yaml 
kubectl apply -f k8s/volumes/airflow-logs-pvc.yaml 


# Upgrade Airflow using Helm
helm upgrade airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml --set-string images.airflow.tag="0.0.1" --debug


# Port forward the API server
kubectl port-forward svc/airflow-api-server 8080:8080 --namespace airflow












# Build the image and load it into kind
# docker build --pull --tag $IMAGE_NAME:$IMAGE_TAG -f cicd/Dockerfile .
# kind load docker-image $IMAGE_NAME:$IMAGE_TAG






# helm upgrade airflow apache-airflow/airflow \
#     --namespace airflow -f chart/values-override.yaml \
#     --set-string images.airflow.tag="$IMAGE_TAG" \
#     --debug
# kubectl create namespace airflow

# helm install airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml --set-string images.airflow.tag="0.0.2" --debug









#get all pods , deployments , services in airflow namespace
# kubectl get all -n airflow
#  kubectl exec -n airflow pod/airflow-dag-processor-6d5674d99b-kqllf  -c dag-processor -- ls -la /opt/airflow/dags/
# kubectl exec -n airflow pod/airflow-dag-processor-6d5674d99b-kqllf  -c dag-processor -- ls -la /opt/airflow/dags/.worktrees/841b7c0c2d12501bd79fe06e0cb467c98496a507


# # for update the git credentials 
# kubectl apply -f k8s/secrets/git-secrets.yaml -n airflow




# #refresh
#  kubectl rollout restart deployment/airflow-dag-processor -n airflow
#  kubectl rollout status deployment/airflow-dag-processor -n airflow --timeout=120s


docker-compose run airflow airflow create-user --username admin  --firstname Admin   --lastname User --role Admin  --email admin@example.com   --password admin