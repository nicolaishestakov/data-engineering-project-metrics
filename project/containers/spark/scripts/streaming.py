from pyspark.sql import SparkSession
from pyspark.sql.functions import col
from pyspark.sql.types import FloatType
from pyspark.sql.functions import input_file_name
import pyspark.sql.functions as F
import os

GcsBucket = os.environ['GCS_BUCKET']  #'zoomcamp-de-project-2024-metrics'


# Initialize SparkSession

spark = SparkSession.builder \
    .appName("CSV to GCS Bucket Streaming") \
    .config("spark.jars", "/opt/spark/jars/gcs-connector-hadoop3-latest.jar") \
    .config("fs.gs.impl", "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem")\
    .getOrCreate()

        

# Define input CSV schema
csv_schema = "file STRING, region STRING, type STRING, modified STRING, line_start STRING, line_end STRING, `std.code.complexity:cyclomatic` FLOAT, `std.code.lines:code` FLOAT"

# Read CSV files from folder as a streaming DataFrame
csv_stream_df = spark.readStream \
    .option("sep", ",") \
    .option("header", "true") \
    .schema(csv_schema) \
    .csv(".")

# Rename columns and select required columns
metrics_df = csv_stream_df \
    .withColumn("csv_filename", F.regexp_extract(F.input_file_name(), r'\/(.+\/)*(.+)\.csv$', 2)) \
    .select(col("csv_filename").alias("commit"),
            col("file").alias("filepath"),
            col("region").alias("area"),
            col("`std.code.complexity:cyclomatic`").cast(FloatType()).alias("std_code_complexity_cyclomatic"),
            col("`std.code.lines:code`").cast(FloatType()).alias("std_code_lines_code"))

# Write streaming DataFrame to BigQuery
query = metrics_df \
        .writeStream \
        .outputMode("append") \
        .format("parquet") \
        .option("path", f"gs://{GcsBucket}/metrics_data") \
        .option("checkpointLocation", f"gs://{GcsBucket}/checkpoint") \
        .start()

# Await termination
query.awaitTermination()