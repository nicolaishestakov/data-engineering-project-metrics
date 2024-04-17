FROM cluster-base

# -- Layer: JupyterLab

ARG spark_version=3.3.1
ARG jupyterlab_version=3.6.1
ARG gcs_bucket=zoomcamp-de-project-2024-metrics

RUN apt-get update -y && \
    apt-get install -y python3-pip && \
    pip3 install wget pyspark==${spark_version} jupyterlab==${jupyterlab_version}

    
RUN mkdir -p /opt/spark/jars 
# Download Google Cloud Spark connector JAR file
RUN wget -O /opt/spark/jars/gcs-connector-hadoop3-latest.jar https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop3-latest.jar


# Copy service account key into the image
COPY keys/gcp-spark-key.json /service-account-key.json

# Set environment variable
ENV GOOGLE_APPLICATION_CREDENTIALS=/service-account-key.json
ENV GCS_BUCKET=${gcs_bucket}

RUN echo SHARED_WORKSPACE "${SHARED_WORKSPACE}"

# -- Runtime

EXPOSE 8888
WORKDIR ${SHARED_WORKSPACE}
CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
