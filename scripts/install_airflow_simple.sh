#!/usr/bin/env bash
set -euo pipefail

# install_airflow_simple.sh
# A very simple, readable list of commands (and reasons) to set up Airflow locally on KIND.
# This file is intentionally minimal and safe; run with `--run` to execute steps interactively.

RUN=false
if [ "${1:-}" = "--run" ]; then
  RUN=true
fi

run() {
  echo
  echo "== $1 =="
  echo "  $2"
  if $RUN; then
    read -p "Run this step now? [y/N] " ans || true
    if [ "${ans,,}" = "y" ]; then
      eval "$2"
    else  
      echo "Skipped"
    fi
  fi
}

# Steps (brief)
run "Create or reset KIND cluster" "kind delete cluster --name kind || true; kind create cluster --image kindest/node:v1.29.4"
run "Add Helm repo and export example values" "helm repo add apache-airflow https://airflow.apache.org && helm repo update && helm show values apache-airflow/airflow > chart/values-example.yaml"
run "Build & load local Airflow image into KIND" "docker build --pull --tag my-dags:0.0.1 -f cicd/Dockerfile . && kind load docker-image my-dags:0.0.1"
run "Create namespace and apply secrets" "kubectl create namespace airflow || true && kubectl apply -f k8s/secrets/git-secrets.yaml || true"
# Note: edit chart/values-override.yaml if you need to override Postgres image or disable git credentials
run "Install Airflow (Helm)" "helm upgrade --install airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml --set-string images.airflow.tag=\"0.0.1\" --timeout 10m0s"
run "Check pods and jobs" "kubectl -n airflow get pods -o wide; kubectl -n airflow get jobs -o wide"
run "Create airflow DB if missing" "kubectl -n airflow exec -it airflow-postgresql-0 -- psql -U postgres -c \"CREATE DATABASE airflow;\" || true"
run "Show migration logs (if needed)" "kubectl -n airflow logs -l job-name=airflow-run-airflow-migrations --all-containers --tail=200 || true"
run "Port-forward API server (open http://localhost:8080)" "kubectl -n airflow port-forward svc/airflow-api-server 8080:8080 --namespace airflow"

# Quick verification
run "Show resources in namespace" "kubectl get all -n airflow"

echo "\nSimple runbook created at scripts/install_airflow_simple.sh"
echo "Run without execution: bash scripts/install_airflow_simple.sh"
echo "Run interactively: bash scripts/install_airflow_simple.sh --run"
