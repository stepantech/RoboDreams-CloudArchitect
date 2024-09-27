# 9. lekce: Redundance a distribuce dat, dostupnost vs. konzistence

## Shared storage vs. Shared nothing
- **Shared storage**: Všechny uzly sdílejí společný diskový systém. Výhodou je jednoduchost a možnost sdílení dat mezi uzly. Nevýhodou je, že sdílený disk může být úzkým hrdlem a zpomalovat celý systém. Tento přístup se často používá u tradičních relačních databází, kde je potřeba transakční konzistence.
- **Shared nothing**: Každý uzel má svůj vlastní diskový systém a data jsou distribuována mezi uzly. Výhodou je vysoká škálovatelnost a odolnost proti výpadkům. Nevýhodou je složitější správa dat a nutnost řešit konzistenci dat. Tento přístup se často používá u NoSQL databází a distribuovaných systémů. Moderní způsob nasazování relační databází často používá už tuto architekturu a replikuje data přímo enginem databáze.

## PACELC (rozšíření CAP teorému) a redundantní či distribuovaná datová vrstva

[PACELC](https://en.wikipedia.org/wiki/PACELC_theorem) teorém je rozšířením známého CAP teorému, který se zabývá kompromisy v distribuovaných systémech. Zatímco CAP teorém tvrdí, že v případě síťového rozdělení (Partition, P) musí systém volit mezi dostupností (Availability, A) a konzistencí (Consistency, C), PACELC teorém přidává další dimenzi: i když nedochází k síťovému rozdělení (Else, E), musí systém volit mezi latencí (Latency, L) a konzistencí (Consistency, C).

| Varianta                          | Rychlost zápisu | Rychlost čtení | Dostupnost | Konzistence | Škálovatelnost |
|-----------------------------------|-----------------|----------------|------------|-------------|----------------|
| Jediná replika                    | Vysoká          | Střední          | Nízká      | Vysoká      | Nízká          |
| Synchronní replikace bez možnosti čtení | Střední         | Vysoká          | Vysoká     | Vysoká      | Spíše nízká        |
| Synchronní replikace s možností čtení  | Nízká         | Vysoká        | Střední     | Vysoká      | Spíše nízká        |
| Asynchronní replikace s možností čtení  | Vysoká          | Vysoká         | Střední     | Nízká       | Spíše nízká         |

Klasické systémy obvykle nevolí varianty připouštějící eventuální konzistenci, zejména při zápisech.

## Laditelnost konzistence
Nejprve proberme [Eventuální konzistenci a řešení nekonzistencí](https://en.wikipedia.org/wiki/Eventual_consistency)

Silná konzistence distribuovaného systému je v případě, že:

$$R + W > N$$

kde R je počet replik, ze kterých se čte, W je počet replik, do kterých se zapisuje a N je celkový počet replik. 

V ostatních případech jde o eventuální konzistenci.

Situace se dále komplikuje tím, že obvykle budeme mít některé repliky lokální (například jedna zóna dostupnosti či region) zatímco jiné budou vzdálené (například jiný region) a pro ladění výkonu můžeme chtít míru eventuální konzistence míchat s ohledem na lokální a globální uzly. Celou problematiku si přibližme na příkladu Cassandra. Můžete si pohrát i s [kalkulačkou](https://www.ecyrd.com/cassandracalculator/).

| Consistency Level | Description |
|-------------------|-------------|
| **ALL**           | Writes/Reads must be written to the commit log and memtable on all nodes in the cluster. |
| **EACH_QUORUM**   | Writes/Reads must be written to the commit log and memtable on each quorum of nodes. Quorum is 51% of the nodes in a cluster. |
| **QUORUM**        | Writes/Reads must be written to the commit log and memtable on a quorum of nodes across all data centers. |
| **LOCAL_QUORUM**  | Writes/Reads must be written to the commit log and memtable on a quorum of nodes in the same datacenter as the coordinator. |
| **ONE**           | Writes/Reads must be written to the commit log and memtable of at least one node. |
| **TWO**           | Writes/Reads must be written to the commit log and memtable of at least two nodes. |
| **THREE**         | Writes/Reads must be written to the commit log and memtable of at least three nodes. |
| **LOCAL_ONE**     | Writes/Reads must be sent to and successfully acknowledged by at least one node in the local datacenter. |
| **ANY**           | Writes/Reads must be written to at least one node. |

> **[Ukázka: Cassandra](Cassandra.md)**

Podívejme se ještě na úrovně konzistence v [Azure CosmosDB](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels).

### Jak řešit konflikty?
- **Last-write-wins**: Poslední zápis přepíše všechny předchozí hodnoty. Nejčastější metoda, používá se třeba u Cassandra, Cosmos DB nebo Aurora.
- **First-write-wins**: Původní zápis přepíše všechny novější hodnoty. 
- **Conflict-free replicated data types (CRDTs)**: Speciální datové typy, které umožňují konfliktní zápisy bez nutnosti řešení konfliktů. Dojde k automatickému sloučení hodnot, merge.
- **Vlastní logika**: vznikne chyba, na kterou je třeba ručně nebo aplikačně reagovat a to buď přímo v databázi (uložená procedura) nebo přes API.

## Sharding
**Sharding** je technika rozdělování databáze na menší části zvané "shardy". Každý shard obsahuje podmnožinu celkových dat a může být uložen na různých serverech, což zvyšuje výkon a škálovatelnost databáze. V nějaké formě se týká všech většiny distribuovaných databází, protože je běžné, že data jsou distribuována na více uzlů. Nicméně zaměřme se tady specificky na relační databáze, kdy jejich omezenou škálovatelnost lze překonat právě shardingem.

> **[Ukázka: Sharding](Sharding.md)**

## Příklad distribuovaných databází v cloudu
- **Azure Cosmos DB**: Nerelační databáze s podporou více modelů konzistence. Nabízí globální distribuci dat a automatické škálování.
- **Amazon Aurora**: Relační databáze kompatibilní s MySQL a PostgreSQL. Využívá replikaci pro vysokou dostupnost a rychlé zotavení.
- **Amazon DynamoDB**: Key-value databáze s automatickým horizontálním škálováním. Podporuje transakce a globální tabulky.
- **Google Cloud Spanner**: Kombinuje relační a nerelační vlastnosti. Poskytuje globální konzistenci a horizontální škálování.
- **Citus pro PostgreSQL**: Rozšiřuje PostgreSQL o horizontální škálování. Vhodné pro analytické a transakční úlohy.
- **Azure SQL Hyperscale**: Relační databáze s architekturou více uzlů. Umožňuje dynamické přidávání úložných a výpočetních prostředků.
- **Greenplum**: Databázový systém založený na PostgreSQL. Navržen pro analýzu velkých datových sad s paralelním zpracováním dotazů.
- **Google AlloyDB**: Databáze založená na PostgreSQL. Nabízí vysokou dostupnost a škálovatelnost s podporou analytických úloh.
- **MongoDB Atlas**: Plně spravovaná NoSQL databáze. Nabízí automatické škálování a globální distribuci dat.
- **CockroachDB**: Distribuovaná SQL databáze navržená pro vysokou dostupnost a horizontální škálování. Podporuje automatické zotavení a replikaci.
- **Apache Cassandra**: NoSQL databáze navržená pro vysokou dostupnost a škálovatelnost. Využívá masterless architekturu a podporuje replikaci napříč datovými centry.
