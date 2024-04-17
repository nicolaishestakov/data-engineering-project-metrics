FROM repo-base

# Copy Python scripts to the container
COPY scripts /app/scripts

EXPOSE 8899
CMD jupyter lab --ip=0.0.0.0 --port=8899 --no-browser --allow-root --NotebookApp.token=
#ENTRYPOINT ["python", "scripts/startup.py"]