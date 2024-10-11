# Databricks notebook source
# MAGIC %md
# MAGIC # Práce s daty
# MAGIC
# MAGIC Nejprve si načteme tisíce JSON souborů a uděláme z nich Delta Lake tabulky.

# COMMAND ----------

storage_account_name = dbutils.secrets.get(scope="azure", key="storage_account_name")
books_storage_location = f"abfss://bronze@{storage_account_name}.dfs.core.windows.net/books"
authors_storage_location = f"abfss://bronze@{storage_account_name}.dfs.core.windows.net/authors"

spark.sql(f"""
CREATE TABLE IF NOT EXISTS mycatalog.mydb.books
USING JSON
LOCATION '{books_storage_location}'
""")


spark.sql(f"""
CREATE TABLE IF NOT EXISTS mycatalog.mydb.authors
USING JSON
LOCATION '{authors_storage_location}'
""")


# COMMAND ----------

# MAGIC %md
# MAGIC Podívejme se na data

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT * FROM mycatalog.mydb.books LIMIT 5

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT * FROM mycatalog.mydb.authors LIMIT 5

# COMMAND ----------

# MAGIC %md
# MAGIC Propojme informace z obou tabulek, abychom získali spojení jména a emailu autora s knihou

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT authors.name, authors.mail, books.title FROM mycatalog.mydb.books
# MAGIC JOIN mycatalog.mydb.authors ON mycatalog.mydb.books.author_id = mycatalog.mydb.authors.author_id
