# AI Stack Exchange Analyzer

This project is an end-to-end data engineering pipeline designed to analyze the [AI Stack Exchange](https://ai.meta.stackexchange.com/) community. It orchestrates the ingestion of raw data from the Internet Archive into a data lake, processes it using PySpark on Databricks, and generates insights via dashboards.

## 📺 Video Walkthroughs

### 🔹 Part 1: System Overview
[![Watch the video](https://img.youtube.com/vi/xYIdiGGgboo/0.jpg)](https://www.youtube.com/watch?v=xYIdiGGgboo)

---

### 🔹 Part 2: Deployment
[![Watch the video](https://img.youtube.com/vi/4EoIlkwag2k/0.jpg)](https://www.youtube.com/watch?v=4EoIlkwag2k)
## Data Source

The dataset is sourced from the Stack Exchange Data Dump on Archive.org:
- **Source URL:** [https://archive.org/download/stackexchange/ai.meta.stackexchange.com.7z](https://archive.org/download/stackexchange/ai.meta.stackexchange.com.7z)
- **Files Processed:** `Posts.xml` and `Users.xml`

## Architecture

1.  **Orchestration (Apache Airflow):**
    -   Airflow is run locally using **Docker Compose**.
    -   The pipeline downloads the compressed `.7z` archive, extracts it, and uploads the raw XML files to an AWS S3 bucket.
    -   Utilizes modern Airflow features like Data-Aware scheduling with Assets.

2.  **Storage (AWS S3):**
    -   All data from pipeline runs is stored in the `data-platform-post-users` S3 bucket.

3.  **Processing & Analysis (Databricks):**
    -   **PySpark** is used for parsing the XML data, data cleaning, and transformation.
    -   **Analysis:** Focuses on User activity and Post content sections.

4.  **Visualization:**
    -   Dashboards created within Databricks to visualize key metrics and insights.

5.  **CI/CD & Deployment:**
    -   A CI/CD pipeline builds the custom Airflow Docker image from the `cicd/Dockerfile`.
    -   The image is pushed to **Amazon ECR (Elastic Container Registry)** for deployment.

## Project Structure

```text
.
├── cicd/                   # Docker build files
│   └── Dockerfile
├── dags/                   # Airflow DAGs (Python)
│   └── produce_data_assets.py
├── docker-compose.yml      # Docker Compose for local environment
└── README.md
```

## Prerequisites

To run the Airflow infrastructure locally, you need:
*   Docker

## Getting Started



**Quickstart:**

Run the interactive quickstart script to set up the cluster, build images, and install Airflow:

```bash
docker-compose up
```

**Accessing the UI:**
Once deployed, port-forward the API server to access the Airflow UI at `http://localhost:8080`:



### 2. Data Pipeline Configuration

The DAGs require a connection to AWS S3. Ensure you have an Airflow Connection configured with the ID `aws_conn` pointing to your AWS credentials.

### 3. Databricks Analysis

1.  Mount the S3 bucket `data-platform-post-users` in your Databricks environment.
2.  Ingest `raw/Posts.xml` and `raw/Users.xml` using PySpark.
3.  Perform transformations to analyze user engagement and post trends.

## Technologies

*   **Apache Airflow** (v3.0.2)
*   **Kubernetes** (KIND)
*   **AWS S3**
*   **Databricks** & **PySpark**
*   **Python** (`py7zr`, `requests`)