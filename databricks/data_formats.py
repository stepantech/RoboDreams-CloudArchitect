# Databricks notebook source
# MAGIC %md
# MAGIC # Oddělení zpracování dat od jejich uložení

# COMMAND ----------

# MAGIC %md
# MAGIC ## Přístup na data ve storage

# COMMAND ----------

# MAGIC %md
# MAGIC Spark umožňuje pracovat s **CSV** souborem ve storage přímo jako s DataFrame objektem a provádět na něm zpracování dat, například různé agregace, filtrace apod.

# COMMAND ----------

storage_account_name = dbutils.secrets.get(scope="azure", key="storage_account_name")
data_path = f"abfss://bronze@{storage_account_name}.dfs.core.windows.net/example/"

# COMMAND ----------

# Read data from CSV into DataFrame
df = spark.read.csv(data_path, header=True, inferSchema=True)

display(df)

# COMMAND ----------

from pyspark.sql import functions as F

# Calculate average age by country
average_age_by_country = df.groupBy("country") \
                           .agg(F.avg("age").alias("average_age")) \
                           .orderBy("average_age")

display(average_age_by_country)

# COMMAND ----------

# MAGIC %md
# MAGIC Pro analýzu velkého množství dat ale nejsou formáty CSV nebo JSON vhodné a špatně škálují. Analytické zpracování se často zaměřuje na operace ve sloupcích na rozdíl od transakčního zpracování, které se častěji týká řádků. Navíc údaje ve sloupcích jde obvykle velmi dobře komprimovat (například v našem sloupci country se nachází jen několik hodnot a ty se často opakují). 
# MAGIC
# MAGIC Open source formát **Parquet** přesně tohle dělá a je tak optimálním způsobem uložení dat pro analytické zpracování. Na rozdíl od proprietárních databázových formátů je možné ho načítat do jakéhokoli nástroje, který se ho rozhodne podporovat a efektivně tak odděluje technologii uložení dat (storage + formát) od technologie pro jejich zpracování.

# COMMAND ----------

# Save data as parquet
parquet_path = f"abfss://bronze@{storage_account_name}.dfs.core.windows.net/example/mydata.parquet"
df.write.mode("overwrite").parquet(parquet_path)

# Read data from parquet
df_parquet = spark.read.parquet(parquet_path)
display(df_parquet)

# COMMAND ----------

# MAGIC %md
# MAGIC ## Databázové chování na Parquet soubory - Delta formát
# MAGIC Parquet umožňuje data uložit způsobem, který je velmi efektivní pro jejich zpracování. Nicméně v databázovém systému je možnost data měnit, přidávat či mazat a při tom vzniká záznam těchto změn - log. To umožňuje nechtěné změny vrátit zpátky, podívat se na snapshot dat k určitému historickému datu a tak podobně. Databázový systém má koncept tabulek a jejich schématu a také podporuje transakce (ACID), takže pokud je potřeba upravit víc jak jedno datové políčko, zajistí, že pokud se všechny změny nepodaří udělat, žádná z nich se nezapíše a udrží se tak konzistence dat (např. při převodu peněz stav, kdy jsem odečetl peníze z jednoho účtu, ale při přičítání do druhého účtu odumřel server).
# MAGIC
# MAGIC I pro tohle existuje otevřené řešení, které nevyžaduje použití proprietárních databázových formátů - Delta.
# MAGIC
# MAGIC Můžeme s ním pracovat v Pythonu, ale pojďme v této fázi přejít na jazyk SQL, který můžete znát ze světa klasických databází.

# COMMAND ----------

unity_catalog_storage_location = f"abfss://bronze@{storage_account_name}.dfs.core.windows.net/mydelta"

spark.sql(f"""
CREATE TABLE mycatalog.mydb.mytable
USING DELTA
LOCATION '{unity_catalog_storage_location}'
AS
SELECT * FROM parquet.`{parquet_path}`
""")

# COMMAND ----------

# MAGIC %md
# MAGIC Založili jsme Delta tabulku a jsou v ní data ze tří zemí.

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT country, count(*) FROM mycatalog.mydb.mytable
# MAGIC GROUP BY country

# COMMAND ----------

# MAGIC %md
# MAGIC V historii vidíme jeden záznam - iniciální vytvoření z našeho souboru

# COMMAND ----------

# MAGIC %sql
# MAGIC DESCRIBE HISTORY mycatalog.mydb.mytable

# COMMAND ----------

# MAGIC %md
# MAGIC Smažeme všechny záznamy z CZ

# COMMAND ----------

# MAGIC %sql
# MAGIC DELETE FROM mycatalog.mydb.mytable
# MAGIC WHERE country = 'CZ'

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT country, count(*) FROM mycatalog.mydb.mytable
# MAGIC GROUP BY country

# COMMAND ----------

# MAGIC %sql
# MAGIC DESCRIBE HISTORY mycatalog.mydb.mytable

# COMMAND ----------

# MAGIC %md
# MAGIC V Azure teď prozkoumáme výsledné soubory

# COMMAND ----------

# MAGIC %md
# MAGIC Zkusme teď spustit SELECT přímo na starší verzi tabulky

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT country, count(*) FROM mycatalog.mydb.mytable
# MAGIC VERSION AS OF 0
# MAGIC GROUP BY country

# COMMAND ----------

# MAGIC %md
# MAGIC Obnovíme teď databáze k verzi 0 a uvidíme, že tím vznikne další záznam v historii

# COMMAND ----------

# MAGIC %sql
# MAGIC RESTORE TABLE mycatalog.mydb.mytable TO VERSION AS OF 0

# COMMAND ----------

# MAGIC %sql
# MAGIC DESCRIBE HISTORY mycatalog.mydb.mytable
