FROM python:3.9

ARG snapshots_dir
ENV SNAPSHOTS_DIR=${snapshots_dir}

ARG metrics_dir
ENV METRICS_DIR=${metrics_dir}

WORKDIR /app

# Install the 'metrixpp' package
RUN pip install metrixpp

# Copy Python scripts to the container
COPY scripts /app/scripts

# the metrics reports will be put here 
RUN mkdir -p ${metrics_dir} 

CMD ["tail", "-f", "/dev/null"]