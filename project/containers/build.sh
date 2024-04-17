# -- Software Stack Version
MSYS_NO_PATHCONV=1

SPARK_VERSION="3.3.1"
HADOOP_VERSION="3"
JUPYTERLAB_VERSION="3.6.1"

REPO_URL="https://github.com/nicolaishestakov/UglyTetris.git"
#REPO_URL= "https://github.com/Revolutionary-Games/Thrive.git"

GCS_BUCKET="zoomcamp-de-project-2024-metrics"

SNAPSHOTS_DIR="//shared/snapshots"
REPO_DIR="//shared/repository"
METRICS_DIR="//shared/metrics"

# -- Building the Images

docker build \
  --build-arg shared_workspace="//shared" \
  -f spark/cluster-base.Dockerfile \
  -t cluster-base ./spark

docker build \
  --build-arg spark_version="${SPARK_VERSION}" \
  --build-arg jupyterlab_version="${JUPYTERLAB_VERSION}" \
  --build-arg gcs_bucket="${GCS_BUCKET}" \
  -t spark ./spark

docker build \
   --build-arg repo_url="${REPO_URL}" \
   --build-arg snapshots_dir="${SNAPSHOTS_DIR}" \
   --build-arg repo_dir="${REPO_DIR}" \
   --build-arg jupyterlab_version="${JUPYTERLAB_VERSION}" \
   -f repo/repo-base.Dockerfile \
   -t repo-base ./repo

docker build \
   -t repo ./repo

docker build \
  --build-arg snapshots_dir="${SNAPSHOTS_DIR}" \
  --build-arg metrics_dir="${METRICS_DIR}" \
  -t metrics-calc ./metrics-calc
      