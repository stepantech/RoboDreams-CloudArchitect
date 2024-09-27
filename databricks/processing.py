# Databricks notebook source
storage_account_name = dbutils.secrets.get(scope="azure", key="storage_account_name")
data_path = f"abfss://bronze@{storage_account_name}.dfs.core.windows.net/myjsons/"
df = spark.read.json(data_path)

display(df)

# COMMAND ----------

filtered_df = df.filter(df.author.contains("John"))
display(filtered_df)

# COMMAND ----------

# MAGIC %md
# MAGIC ## Výsledky
# MAGIC
# MAGIC | Node CPU | Node RAM | Node count | Total CPU | Total RAM | 10k Ingestion time | 100k Ingestion time | 10k Query time | 100k Query time |
# MAGIC | --- | --- | --- | --- | --- | --- | --- | --- | --- |
# MAGIC | 4 | 16 | 1 | 4 | 16 | 104 | 589 |4.05 | 197 |
# MAGIC | 16 | 64 | 4 | 16 | 64 | 45 | 216 | 1.72 | 54 |
# MAGIC | 4 | 16 | 3+1 | 16 | 64 | 71 | 257 | 7.51 | 65 |
# MAGIC | 4 | 16 | 4+1 | 20 | 80 | 56 | 221 |6.26 | 49 | 
# MAGIC | 4 | 16 | 8+1 | 36 | 144 | 49 | 175 | 4.60 | 28 |
