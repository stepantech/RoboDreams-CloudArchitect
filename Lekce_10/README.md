# 10. lekce: Distribuované zpracování a analýza dat

## Oddělení dat od compute se Spark a Lakehouse architekturou

### Historický kontext a vývoj

V počátcích velkých datových analýz se používaly tradiční datové sklady (DWH), které byly optimalizovány pro strukturovaná data a dávkové zpracování. Nicméně, s nárůstem objemu a různorodosti dat se objevily nové výzvy, které tradiční DWH nedokázaly efektivně řešit.

### MapReduce Algoritmus

MapReduce, vyvinutý společností Google, byl jedním z prvních kroků k řešení těchto výzev. Tento algoritmus umožňuje distribuované zpracování velkých datových sad na clusteru počítačů. Proces se skládá ze dvou hlavních fází:

- **Map**: Rozdělení úlohy na menší podúlohy, které jsou zpracovány paralelně.
- **Reduce**: Agregace výsledků z fáze Map do konečného výstupu.

MapReduce byl základem pro mnoho raných big data technologií, včetně Apache Hadoop.

### Apache Spark

Apache Spark byl vyvinut jako odpověď na některé omezení MapReduce, zejména jeho vysokou latenci a složitost při zpracování iterativních úloh. Spark nabízí několik klíčových výhod:

- **In-memory computing**: Umožňuje uchovávat data v paměti mezi jednotlivými kroky zpracování, což výrazně zrychluje iterativní úlohy.
- **Jednotné API**: Podporuje různé typy úloh (batch, streaming, machine learning) v rámci jednoho API.
- **Škálovatelnost**: Schopnost zpracovávat petabajty dat na tisících uzlech.

### Lakehouse Architektura

Lakehouse architektura, jako je Databricks, kombinuje výhody data lake a data warehouse:

- **Data Lakes**: Umožňují ukládání velkých objemů nestrukturovaných a semi-strukturovaných dat.
- **Data Warehouses**: Optimalizované pro strukturovaná data a analytické dotazy.

Lakehouse poskytuje jednotné úložiště pro všechny typy dat a podporuje různé analytické úlohy, což zjednodušuje správu dat a zvyšuje flexibilitu. V jistém pohledu se jedná o standardizaci a rozebrání databáze:

- **Parquet soubory**: Představují to, co dělaly data files v databázích, umožňují efektivní ukládání a přístup k velkým objemům dat.
- **Delta formát**: Přidává do tohoto systému transakční log, což umožňuje ACID vlastnosti a zajišťuje konzistenci dat.

### Dotazovací jazyk
Tradičně byla dotazování na data psaná jako kód v Javě, což vyžadovalo pokročilé programátorské dovednosti. Postupem času se však objevily knihovny pro Python a dokonce i podpora klasického SQL jazyka, což zpřístupnilo tuto technologii širšímu okruhu uživatelů, včetně klasických datařů a neprogramátorů.

- **PySpark**: PySpark je rozhraní pro Apache Spark v Pythonu. Umožňuje uživatelům psát Spark aplikace pomocí Pythonu, což je jeden z nejpopulárnějších programovacích jazyků pro datovou vědu a analýzu. PySpark poskytuje přístup ke všem funkcím Spark, včetně Spark SQL, DataFrame API, Machine Learning Library (MLlib) a GraphX.
- **Pandas**: Pandas je knihovna pro analýzu dat v Pythonu. Poskytuje snadný a efektivní způsob manipulace s daty, včetně načítání, filtrování, transformace a vizualizace dat a je velmi oblíbená mezi datovými analytiky a vědci. Nicméně je to princiálně single-node knihovna, což znamená, že je omezena velikostí dat, které může zpracovat. Nicméně Spark přišel s "předělávkou" Pandas pro distribuované prostředí, původně pod názvem Koalas a později přejmenované na Pandas API pro Spark.
- **Spark SQL**: Spark SQL je modul Apache Spark pro strukturované zpracování dat. Umožňuje uživatelům dotazovat a analyzovat data pomocí SQL nebo HiveQL, což je SQL podmnožina používaná v Apache Hive. Spark SQL poskytuje výhody strukturovaného zpracování dat, jako jsou DataFrame a Dataset API, optimalizace dotazů a integrace s existujícími nástroji pro business intelligence (BI).

### Srovnání s tradiční analýzou dat v DWH

- **Tradiční DWH**: Optimalizované pro strukturovaná data a dávkové zpracování. Vysoké náklady na škálování, omezená flexibilita při práci s nestrukturovanými daty, vysoká latence.
- **Spark a Lakehouse**: Umožňují zpracování různých typů dat (strukturovaná, nestrukturovaná) a podporují různé typy úloh (batch, streaming, machine learning). Nižší náklady na škálování díky oddělení úložiště a výpočetních zdrojů, lepší otevřenost a flexibilita.

> **[Ukázka: Data v Databricks](Databricks.md)**

## Streaming data

Streaming data umožňuje zpracování dat v reálném čase nebo téměř v reálném čase, což je klíčové pro aplikace, které vyžadují aktuální informace.

- **Microbatching**: Technika, kde jsou data zpracovávána v malých dávkách, což umožňuje rychlejší zpracování než tradiční batch processing.
- **Spark Structured Streaming**: API pro zpracování streamovaných dat, které umožňuje psát streamovací aplikace stejným způsobem jako batch aplikace.
- **Databricks Delta Live Tables**: Automatizuje ETL procesy pro streamovaná data, zajišťuje kvalitu dat a poskytuje možnosti pro monitoring a správu.

Míra čerstvosti dat, tedy jak aktuální data potřebujete, má přímý vliv na architekturu a náklady.

- **Batch processing**: Vhodné pro aplikace, které nepotřebují data v reálném čase. Nižší náklady, ale vyšší latence.
- **Near-real-time processing**: Kompromis mezi náklady a latencí. Vhodné pro aplikace, které potřebují data s malým zpožděním.
- **Real-time processing**: Nejvyšší náklady, ale nejnižší latence. Vhodné pro kritické aplikace, které vyžadují okamžité reakce na data.

> **[Ukázka: Streaming](Databricks.md)**