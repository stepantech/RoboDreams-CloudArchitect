# Cassandra
V této ukázce jsme nasadili spravovanou Cassandru v Azure ve 3 různých regionech, přičemž v každém regionu jsou 3 instance. Podívejme se na to v portálu.

V Container Apps běží kontejner s několika testovacími Python skripty. Přejděte do konzole tohoto kontejneru.

Nejprve spusťte `python setup.py`, který vytvoří keyspace a několik tabulek s různými replikacemi. Podívejte se na kód s CQL příkazy a diskutujte o různých nastaveních.

Dále otestujeme výkon v extrémním scénáři pomocí strategie 3 replik ve 3 regionech, od velmi slabé konzistence (ONE) až po velmi silnou (ALL), a změříme rychlost zápisu a čtení.

Spusťme test zápisu pomocí různých úrovní konzistence a získejme tabulku s výsledky spuštěním `python write_speed.py`.

Nyní spusťme test čtení pomocí různých úrovní konzistence a získejme tabulku s výsledky spuštěním `python read_speed.py`.

Výsledné soubory lze nahrát do Azure Storage Account pomocí `python upload.py`.

Toto provedeme živě, ale můžete vidět mé předchozí výsledky ve složce cassandra_results.