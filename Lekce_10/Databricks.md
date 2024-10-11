# Databricks demo
Po nasazení připojte svůj workspace k našemu git repozitáři, abyste viděli notebooky.

## Test škálování
Chcete-li spustit test škálování sami, odkomentujte velké multi-node clustery v souboru `databricks.compute.tf` ve složce terraform.

Otevřeme notebook `processing` v Databricks a probereme mé předchozí výsledky. Jak uvidíme, výkon se škáluje poměrně lineárně s počtem uzlů.

## Formáty souborů
Otevřete notebook `data formats` a podívejte se, jak lze na Databricks použít různé formáty souborů. Podíváme se na CSV vs. Parquet vs. Delta Lake.

## Streaming
Přejděte do Delta Live Tables a vytvořte vestavěný demo scénář.