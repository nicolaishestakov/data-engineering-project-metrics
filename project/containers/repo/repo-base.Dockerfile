FROM python:3.9

ARG repo_url
ARG repo_dir
ARG snapshots_dir
ARG jupyterlab_version=3.6.1

ENV REPO_URL=${repo_url}
ENV SNAPSHOTS_DIR=${snapshots_dir}
ENV REPO_DIR=${repo_dir}



WORKDIR /app

RUN pip install pandas gitpython

RUN apt-get update && apt-get install -y git

RUN apt-get update -y && \
    apt-get install -y python3-pip && \
    apt-get install -y git && \
    pip3 install wget jupyterlab==${jupyterlab_version}

# Copy Python scripts to the container
COPY scripts /app/scripts

EXPOSE 8899
CMD jupyter lab --ip=0.0.0.0 --port=8899 --no-browser --allow-root --NotebookApp.token=
#ENTRYPOINT ["python", "scripts/startup.py"]