# Databricks notebook source
# MAGIC %md
# MAGIC # Příprava dat pro Machine Learning, feature engineering
# MAGIC
# MAGIC Nejdřív si načtěme data z CSV do tabulky

# COMMAND ----------

storage_account_name = dbutils.secrets.get(scope="azure", key="storage_account_name")
path = f"abfss://bronze@{storage_account_name}.dfs.core.windows.net/example/lending_club.csv"

# Load CSV file
df = spark.read.format("csv") \
  .option("inferSchema", True) \
  .option("header", True) \
  .option("sep", ",") \
  .option("multiline", True) \
  .load(path)

# This public data is anonymous, but for our purposes let's pretend we have personalized data
# Add user_id column
from pyspark.sql.functions import monotonically_increasing_id

df = df.withColumn("user_id", monotonically_increasing_id())

# dti column is in infered schema misdetected as string, fix it
from pyspark.sql.functions import col
df = df.withColumn('dti', col('dti').cast('double'))
df = df.withColumn('open_acc', col('open_acc').cast('double'))
df = df.withColumn('mort_acc', col('mort_acc').cast('double'))

display(df.limit(5))

# COMMAND ----------

# MAGIC %md
# MAGIC ## Chybějící data
# MAGIC Podle situace můžeme smazat řádky, smazat celou feature (sloupeček) nebo data nějak opravit, dopočítat, například dosazením nuly, průměru nebo kategorie "Unknown"

# COMMAND ----------


# Do we have any missing data in columns?
missing_counts = [(column, df.filter(df[column].isNull()).count()) for column in df.columns]
missing_counts_sorted = sorted(missing_counts, key=lambda x: x[1], reverse=True)

for column, count in missing_counts_sorted:
    if count > 0:
        print(column, ":", count) 

# COMMAND ----------

# mort_acc -> fill with mean
from pyspark.sql.functions import mean

mean_mort_acc = df.select(mean("mort_acc")).collect()[0][0]
df = df.fillna(mean_mort_acc, subset=["mort_acc"])

# emp_title -> fill with category Unknown
df = df.fillna("Unknown", subset=["emp_title"])

# emp_length -> fill with most common categorical value
emp_length_mode = df.groupBy('emp_length').count().orderBy('count', ascending=False).first()[0]
df = df.fillna(emp_length_mode, subset=['emp_length'])

# Other columns missing values are in low numbers and we safely drop those rows
df = df.dropna()

# COMMAND ----------

# We will drop features we do not need. Grade is part of subgrade and issue_d is not needed, because it will not exist yet in new data
df = df.drop("grade", "issue_d")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Katagorická data
# MAGIC Kategorická data jsou pro matematické operace klasického ML špatně uchopitelná, nelze jen jednoduše každému přiřadit číslo, protože by to pak bral model jako pořadí (je pes 5x víc než stůl, protože má 5x vyšší ID?). To vede typicky na one-hot-encoding, tady že pro každou možnou hodnotu se vytvoří separátní sloupeček obsahující jen informaci 0 či 1 (ano nebo ne). Například místo sloupce pohlaví uděláme sloupec muž, žena, ostatní. Nicméně pokud může kategorický sloupec mít tisíce hodnot, tak už nám vzniká hodně sloupečků a může tím růst složitost modelu a s tím spojené nepříjemnosti (výpočetní náročnost, špatná interpretovatelnost, overfit). Bude tedy dobré kategorie držet nějak na uzdě.

# COMMAND ----------

# We might want to limit some categorical values by introducing Other
# emp_title (job title) and title (title of loan) consist of 10000 different titles
display(df.groupBy("emp_title").count().orderBy("count", ascending=False).head(50))
display(df.groupBy("emp_title").count().orderBy("count", ascending=False).tail(50))



# COMMAND ----------

# Keep top 30 and rest replace with Other
from pyspark.sql.functions import when

top30_emp_title = [x[0] for x in df.groupBy("emp_title").count().orderBy("count", ascending=False).take(30)]
df = df.withColumn("emp_title", when(df["emp_title"].isin(top30_emp_title), df["emp_title"]).otherwise("Other"))

top30_title = [x[0] for x in df.groupBy("title").count().orderBy("count", ascending=False).take(30)]
df = df.withColumn("title", when(df["title"].isin(top30_title), df["title"]).otherwise("Other"))

# COMMAND ----------

# Feature term can be converted from string to number
from pyspark.sql.functions import regexp_extract
df = df.withColumn("term", regexp_extract("term", "\d+", 0).cast("integer"))

# COMMAND ----------

# Check categories of home_ownership
display(df.groupBy("home_ownership").count())

# COMMAND ----------

# Let's consolidate categories ANY, OTHER and NONE into single category OTHER
from pyspark.sql.functions import when

df = df.withColumn("home_ownership", when(df["home_ownership"].isin({"NONE", "ANY"}), "OTHER").otherwise(df["home_ownership"]))


# COMMAND ----------

# Address is very specific, would be very high cardinality categorical feature
# Let's parse zip code out of and work with that to lower cardinality
df = df.withColumn("zip_code", df["address"].substr(-5, 5))
df = df.drop("address")

# COMMAND ----------

# earliest_cr_line is too granular, for us year is enough, let's parse it as number
df = df.withColumn("earliest_cr_year", df["earliest_cr_line"].substr(-4, 4).cast("integer"))
df = df.drop("earliest_cr_line")

# COMMAND ----------

display(df.limit(10))

# COMMAND ----------

# MAGIC %md
# MAGIC S tako očištěnými daty můžeme dál pracovat v nějaké platformě pro trénování modelů jako je Databricks, Azure Machine Learning, GoogleVertex AI nebo ARS SageMaker.
