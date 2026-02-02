#!/usr/bin/env bash
set -euo pipefail

# airflow_quickstart.sh
# Purpose: printable/runable quickstart runbook for setting up Airflow on KIND (local dev).
# Usage:
#   - To print the steps:   bash scripts/airflow_quickstart.sh
#   - To run interactively: bash scripts/airflow_quickstart.sh --run  (prompts before destructive steps)

RUN=false
if [[ ${1:-} == "--run" ]]; then
  RUN=true
fi

echo "\n=== Airflow Quickstart / Runbook ===\n"

check_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "⚠️  Required tool '$1' is missing. Install it and re-run this script." >&2
    exit 1
  fi
}

# 1) Prereqs
echo "1) Prerequisites (local machine):"
echo "   - docker, kind, kubectl, helm must be installed"
check_cmd docker
check_cmd kind
check_cmd kubectl
check_cmd helm
echo "   OK: prerequisites present\n"

# Helper to display & optionally run commands
run_or_print() {
  local desc="$1"
  local cmd="$2"
  echo "[STEP] $desc"
  echo "  ➜ $cmd"
  if $RUN; then
    read -r -p "Run this step now? [y/N] " ans || true
    if [[ "${ans,,}" == "y" ]]; then
      echo "--> running: $cmd"; eval "$cmd"
    else
      echo "--> skipped"
    fi
  fi
  echo
}

# 2) Create / reset kind cluster
run_or_print "Delete and create a fresh KIND cluster (clean environment)" "kind delete cluster --name kind; kind create cluster --image kindest/node:v1.29.4"

# 3) Add Helm repo & export defaults
run_or_print "Add Apache Airflow helm repo and export default values" "helm repo add apache-airflow https://airflow.apache.org && helm repo update && helm show values apache-airflow/airflow > chart/values-example.yaml"

# 4) Build image and load into kind
run_or_print "Build local Airflow image (contains your DAGs) and load into KIND" "docker build --pull --tag my-dags:0.0.1 -f cicd/Dockerfile . && kind load docker-image my-dags:0.0.1"

# 5) Create namespace & apply secrets
run_or_print "Create 'airflow' namespace and apply git-secrets (if present)" "kubectl create namespace airflow || true && kubectl apply -f k8s/secrets/git-secrets.yaml || true"

# 6) Edit chart/values-override.yaml (manual step)
cat <<'EOF'
6) Review / edit chart/values-override.yaml before install
   - If you hit ImagePullBackOff for Postgres, add:

postgresql:
  enabled: true
  image:
    repository: postgres
    tag: "15"
    pullPolicy: IfNotPresent
  auth:
    username: postgres
    password: postgres
    database: airflow

   - If git-sync init containers fail due to missing secret, set:

dags:
  gitSync:
    credentialsSecret: null

(These edits are typically manual; update file then continue.)
EOF

# 7) Install/Upgrade Helm chart
run_or_print "Install Airflow via Helm (runs post-install hooks: migrations)" "helm upgrade --install airflow apache-airflow/airflow --namespace airflow -f chart/values-override.yaml --set-string images.airflow.tag=\"0.0.1\" --debug --timeout 10m0s"

# 8) Watch pods/jobs
run_or_print "List pods and jobs (verify migrations hook)" "kubectl -n airflow get pods -o wide; kubectl -n airflow get jobs -o wide"
run_or_print "Tail migration logs if required" "kubectl -n airflow logs -l job-name=airflow-run-airflow-migrations --all-containers --tail=200 || true"

# 9) Typical fixes (inspect and fix Postgres DB)
echo "Common fixes (run as needed):"
echo "  - If linux/bitnami Postgres image is not found: override postgresql.image in values and helm upgrade"
echo "  - If Postgres says 'database \"airflow\" does not exist', create it:"
echo "      kubectl -n airflow exec -it airflow-postgresql-0 -- psql -U postgres -c \"CREATE DATABASE airflow;\""

# 10) Verify core components are Ready
run_or_print "Ensure api-server, scheduler, triggerer, dag-processor are running" "kubectl -n airflow get pods -o wide && kubectl -n airflow logs -l component=api-server --tail=200 || true"

# 11) Finally port-forward the API server (UI)
run_or_print "Port-forward the API server (UI)" "kubectl -n airflow port-forward svc/airflow-api-server 8080:8080 --namespace airflow"

echo "\n=== End of runbook ==="
if ! $RUN; then
  echo "\nTo execute interactively, run:"
  echo "  bash scripts/airflow_quickstart.sh --run"
fi
