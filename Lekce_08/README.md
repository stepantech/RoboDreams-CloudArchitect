# 8. lekce: Typy uložení dat v cloudu a výkonnostní aspekty

## Bloková storage vs. Souborová storage vs. Objektová storage vs. Databáze

### Bloková storage
**Hlavní vlastnosti:**
- Data jsou rozdělena do bloků stejné velikosti.
- Každý blok má jedinečný identifikátor.
- Vysoký výkon a nízká latence.

**Typické použití:**
- Databáze s vysokými nároky na výkon.
- Virtuální disky pro servery a aplikace.

**Příklady:**
- AWS EBS (Elastic Block Store), Azure Disk, Google Persistent Disk.
- iSCSI storage (například Azure Elastic SAN) - bloková storage přes TCP síť.

### Souborová storage
**Hlavní vlastnosti:**
- Data jsou organizována v hierarchii složek a souborů.
- Snadný přístup a správa souborů.
- Vhodné pro sdílení souborů mezi uživateli.

**Typické použití:**
- Sdílené síťové disky.
- Dokumenty, obrázky, videa.

**Příklady:**
- AWS EFS (Elastic File System), Azure Files, Google Filestore
- NetApp

### Objektová storage
**Hlavní vlastnosti:**
- Data jsou uložena jako objekty s metadaty.
- Vysoká škálovatelnost a dostupnost.
- Optimalizováno pro velké objemy nestrukturovaných dat.

**Typické použití:**
- Zálohování a archivace dat.
- Ukládání multimediálních souborů a velkých datových sad (Data Lake)

**Příklady:**
- AWS S3 (Simple Storage Service), Azure Blob Storage, Google Cloud Storage
- MinIO (open-source objektová storage)

### Databáze
**Hlavní vlastnosti:**
- Strukturované ukládání dat s možností dotazování.
- Podpora transakcí a integritních omezení.
- Různé typy databází (relační, NoSQL).

**Typické použití:**
- Aplikace vyžadující komplexní dotazování a analýzu dat.
- Systémy pro správu zákazníků (CRM), finanční systémy.

**Příklady:**
- MySQL, PostgreSQL, Microsoft SQL
- MongoDB, Cassandra, DynamoDB, Cosmos DB

> **[Ukázka: Objektová storage](object_storage.md)**

## Mutable vs. immutable (append-only) perzistence a použití v různých systémech (Blob/S3, Kafka, ...)
**Immutable** systémy ukládají data tak, že je nelze modifikovat (update operace) nebo dokonce ani mazat (delete). Obrovskou výhodou takového přístupu je jednodušší řízení konzistence při souběžných zápisech z několika stran. Tím, že data nelze měnit, je zajištěna jejich integrita a historie změn je snadno sledovatelná a auditovatelná. Například při replikaci v distribuovaném systému tak máme "jen" stavy, kdy některá data na daném místě ještě nejsou, ale ne stavy, kdy si data protiřečí. 

Z těchto důvodů se immutable perzistence používá například v:
- **Blockchain** je typickým představitelem, kdy se finanční i jiné transakce navždy ukládají do kryptograficky prokazatelných řetězců a nelze je měnit. Stav peněženky lze kdykoliv zjistit přehráním všech transakcí od počátku věků.
- **Kafka** používá append-only log pro zpracování událostí
- **Git** je distribuovaná databáze, která ukládá všechny změny v kódu jako immutable objekty
- **Objektová storage** jako Azure Blob je obvykle řešena jako immutable (objekty mají pouze simulovanou UPDATE operaci, kdy se ve skutečnosti vytvoří nový objekt)
- **WORM** (Write-Once-Read-Many) aka garantované úložiště je souborový systém, který nelze měnit, například pro archivaci dat pro compliance
- **CQRS a Event Sourcing patterny** v architektuře aplikací využívají immutable proud událostí, dat nebo příkazů

**Mutable** systémy umožňují data měnit, přepisovat nebo mazat. Tento přístup poskytuje větší flexibilitu při správě dat, ale také vyžaduje pečlivější řízení konzistence a integrity dat. Typické příklady zahrnují:
- Bloková storage
- Relační databáze
- NoSQL databáze
- Obvyklé souborové systémy (NTFS, ext4)

Někdy může být výhodné používat kombinaci nebo se využívá jedné techniky pod kapotou té druhé:
- **Databáze s immutable logem** kdy například PostgreSQL má write-ahead log, který je immutable a slouží k obnově databáze po pádu. Pro urychlení ale typicky použijete nějakou celou či rozdílovou zálohu a teprve z tohoto bodu projedete log - důvodem je rychlost a efektivita.
- **Copy-on-write** je technika, kdy se nový stav vytvoří tak, že se změny zapisují do nového místa a až po úspěšném zápisu se změní ukazatel na nový stav. Je tak možné udělat například snapshot, zmražení stavu disku k určitému okamžiku, aniž by v tento moment bylo potřeba data někam stěhovat - je to pouze operace s metadaty. Teprve při změnách se začíná obsazovat další část storage jak vznikají nové bloky.
- **Multi Version Concurency Control** používá verzování pro řízení souběžnosti. Každá změna dat vytváří novou verzi, což umožňuje snadné sledování historie a zajištění konzistence při souběžných operacích. Například v distribuovaných databázích jako Cassandra se používá verzování pro řešení konfliktů při zápisu. V relačních databázích může být použito k zajištění izolace transakcí (transakce nevidí změny ostatních transakcí) s menšími dopady na výkon, než klasické zámečky.
- **Materialized View** je obecně postup, kdy vytvoříme kukátko do dat, které je pro čtení a není primárním zdrojem dat. S trochou nadsázky bychom mohli říct, že datové soubory relační databáze jsou takové materialized view nad logem databáze. Takhle se to ale obvykle nevnímá, nicméně dobrým příkladem může být třeba vytvoření materialized view z průběžného poslouchání událostí z Event Sourcing. Vytváříme obraz situace pro rychle čtení bez nutnosti události přehrávat.

## Optimalizace na čtení vs. zápis
Optimalizace úložišť pro čtení nebo zápis závisí na konkrétních potřebách aplikace a typu dat, která jsou ukládána a zpracovávána. Některé systémy jsou navrženy tak, aby poskytovaly vysoký výkon při čtení, zatímco jiné se zaměřují na efektivní zápis. 

Zamysleme se nad pořádkem ve skříni vs. rychlost zápisu a čtení. Na této analogii uvidíme různé přístupy k optimalizaci čtení, zápisu nebo někde mezi tím. Zdůrazníme zejména nutnost **vynutit strukturu** a ještě hůře **znát strukturu dopředu**.

Praktické dopady jsou například:
- Relační tabulka bez indexů je optimalizovaná pro zápis, protože tyto zápisy nic nebrzdí. Nicméně až budeme vyhledávat, chybějící indexy budou znamenat, že to bude mnohem pomalejší. Naopak - pokud při uložení provedeme spočítání mnoha indexů, zpomalíme zápis, ale zrychlíme čtení.
- Data lake je příklad extrémní optimalizace pro zápis a totální flexibilitu struktury dat. Zapíšu všechno jako soubor a neřeším vůbec nic, ani jaké to má sloupečky. Nicméně analyzovat tato data je náročné a zdlouhavé a vede na datovou analytiku (to si probereme v pozdějších lekcích).
- Analytická relační databáze může používat nejen sloupcové indexy, ale i rozprostření dat přes vícero nodů. Je optimalizovaná na co nejrychlejší odpověď na analytické dotazy (jaký byl průměrný prodej včera večer v Praze) a naopak je velmi pomalá na zápisy (přidání nového záznamu). Proto obvykle nechcete mít transakční a analytické potřeby pokryté stejnou databází, protože byste museli dělat velké kompromisy.

> **[Ukázka: Optimalizace na čtení vs. zápis](read_write_tradeoff.md)**

## Bloková storage a výkonnostní charakteristiky (IOPS vs. throughput vs. latence)

Bloková storage je typ úložiště, kde jsou data rozdělena do bloků stejné velikosti. Každý blok má jedinečný identifikátor, což umožňuje rychlý přístup a manipulaci s daty. Výkonnost blokové storage je často hodnocena pomocí tří hlavních metrik: IOPS, throughput a latence.

### IOPS (Input/Output Operations Per Second)
**Hlavní vlastnosti:**
- **Definice:** IOPS měří počet vstupně-výstupních operací (čtení a zápisů), které může úložiště provést za jednu sekundu.
- **Význam:** Vyšší IOPS znamená lepší schopnost úložiště zvládat náhodné I/O operace, což je klíčové pro aplikace s vysokými nároky na výkon, jako jsou databáze a virtualizace¹(https://www.simplyblock.io/post/iops-throughput-latency-explained).
- **Faktory ovlivňující IOPS:** Typ disku (HDD vs. SSD), velikost bloku, sekvenční vs. náhodný přístup, a konfigurace RAID.

### Throughput
**Hlavní vlastnosti:**
- **Definice:** Throughput měří množství dat, které může být přeneseno za určitou dobu, obvykle vyjádřeno v megabajtech za sekundu (MB/s).
- **Význam:** Vyšší throughput znamená rychlejší přenos velkých objemů dat, což je důležité pro aplikace jako jsou multimediální streamování a zálohování velkých datových sad²(https://www.buffalotech.com/blog/iops-vs-throughput-what-is-the-difference-and-how-do-they-affect-storage-performance).
- **Faktory ovlivňující throughput:** Šířka pásma sítě, efektivita úložiště při zpracování velkých datových objemů, a typ připojení (např. SATA, SAS, NVMe).

### Latence
**Hlavní vlastnosti:**
- **Definice:** Latence měří dobu zpoždění mezi odesláním požadavku na I/O operaci a obdržením odpovědi.
- **Význam:** Nižší latence znamená rychlejší odezvu systému, což je kritické pro aplikace vyžadující rychlou interakci, jako jsou transakční systémy a real-time aplikace³(https://www.nitinfotech.com/understanding-iops-vs-throughput/).
- **Faktory ovlivňující latenci:** Typ úložiště (SSD má nižší latenci než HDD), síťová latence, a zpracování požadavků na úložišti.

### Příklady extrémních situací
- Je možné mít IOPS 5000 při latenci 1 vteřina? Ano! Ale znamená to nečekat, tedy například mít 5000 vláken, které čtou paralelně. Starší aplikace mohou přistupovat na storage čistě synchronně a je jejich výkonu pak rozhoduje především latence.
- Jsou situace, kdy potřebuji masivní throughput, latence mě nezajímá vůbec a IOPS jen přiměřeně? Ano! Představte si streaming videa.
- Můžu potřebovat vysoké IOPS, ale přitom moc neřešit throughput? Ano! Například databáze, do které zapisuji a čtu malinké záznamy třeba o velikosti 1 kB. V krajním případě pak velmi slušných 10 000 IOPS potřebuje jen 10 MBps. Jinak řečeno velikost bloku hraje ve vztahu mezi IOPS a throughput velkou roli.


## Relační databáze
Relační databáze jsou systémy pro správu dat, které organizují data do tabulek (relací). Každá tabulka obsahuje řádky (záznamy) a sloupce (atributy). Relační databáze umožňují efektivní ukládání, dotazování a manipulaci s daty pomocí jazyka SQL (Structured Query Language).

### ACID vlastnosti
ACID je zkratka pro čtyři klíčové vlastnosti, které zajišťují spolehlivost transakcí v relačních databázích:
- **Atomicity (Atomicita):** Každá transakce je buď plně provedena, nebo vůbec neprovedena.
- **Consistency (Konzistence):** Transakce přenáší databázi z jednoho konzistentního stavu do druhého.
- **Isolation (Izolace):** Současné transakce probíhají izolovaně, takže jedna transakce neovlivňuje druhou.
- **Durability (Trvanlivost):** Po potvrzení transakce jsou změny trvalé, i v případě selhání systému.

### Normalizace
Normalizace je proces organizace dat v databázi tak, aby se minimalizovala redundance a zlepšila integrita dat. Tento proces zahrnuje rozdělení velkých tabulek na menší, propojené tabulky a definování vztahů mezi nimi. Normalizace pomáhá zamezit anomáliím při vkládání, aktualizaci a mazání dat.

### Nejčastěji používané relační databáze
- **Microsoft SQL Server (MS SQL)**
- **Oracle Database**
- **MySQL**
- **PostgreSQL**

> **Ukázka: Relační databáze**

## NoSQL databáze
NoSQL databáze jsou navrženy pro ukládání a správu typicky semi-strukturovaných dat, což je odlišuje od tradičních relačních databází. NoSQL databáze jsou často využívány pro jejich flexibilitu, škálovatelnost a schopnost zpracovávat velké objemy dat.

### Typy NoSQL databází

#### Document Storage
**Hlavní vlastnosti:**
- **Struktura:** Data jsou ukládána ve formě dokumentů, obvykle ve formátu JSON, BSON nebo XML.
- **Flexibilita:** Každý dokument může mít jinou strukturu, což umožňuje snadné přizpůsobení změnám v datech.
- **Dotazování:** Podpora pro složité dotazy a indexování.

**Příklad:**
- **MongoDB:** Jedna z nejpopulárnějších NoSQL databází, která ukládá data ve formě dokumentů ve formátu BSON. MongoDB je známá svou flexibilitou a škálovatelností.

#### Key/Value Storage
**Hlavní vlastnosti:**
- **Struktura:** Data jsou ukládána jako páry klíč-hodnota, kde klíč je jedinečný identifikátor a hodnota může být jakýkoliv typ dat.
- **Jednoduchost:** Rychlý přístup k datům pomocí klíče, ideální pro jednoduché dotazy a vysokou rychlost zápisu a čtení.
- **Škálovatelnost:** Snadné horizontální škálování.

**Příklad:**
- **Cassandra:** Distribuovaná NoSQL databáze navržená pro vysokou dostupnost a škálovatelnost. Cassandra používá model klíč-hodnota a je optimalizována pro rychlé zápisy.

#### Graph Storage
**Hlavní vlastnosti:**
- **Struktura:** Data jsou ukládána ve formě uzlů (nodes) a hran (edges), což umožňuje reprezentaci a dotazování složitých vztahů mezi daty.
- **Dotazování:** Podpora pro grafové dotazy, které umožňují efektivní navigaci a analýzu vztahů mezi daty.
- **Použití:** Ideální pro aplikace, které vyžadují analýzu sítí, jako jsou sociální sítě, doporučovací systémy a řízení vztahů se zákazníky (CRM).

**Příklad:**
- **Neo4j:** Populární grafová databáze, která umožňuje ukládání a dotazování dat ve formě grafů. Neo4j je známá svou schopností efektivně zpracovávat složité vztahy mezi daty.

### Rozdíly oproti relačním databázím
- **Struktura dat:** Relační databáze ukládají data do tabulek s pevně definovanou strukturou, zatímco NoSQL databáze umožňují flexibilnější struktury dat (dokumenty, klíč-hodnota, grafy).
- **Schéma:** Relační databáze vyžadují předem definované schéma, zatímco NoSQL databáze mohou pracovat bez pevně definovaného schématu.
- **Škálovatelnost:** NoSQL databáze jsou navrženy pro horizontální škálování, což znamená, že mohou snadno přidávat další servery pro zvýšení kapacity. Relační databáze jsou obvykle optimalizovány pro vertikální škálování (zvýšení výkonu jednoho serveru).
- **ACID vs. BASE:** Relační databáze dodržují ACID vlastnosti (Atomicita, Konzistence, Izolace, Trvanlivost), zatímco NoSQL databáze často dodržují BASE principy (Basically Available, Soft state, Eventual consistency), což umožňuje vyšší škálovatelnost a dostupnost za cenu okamžité konzistence.

NoSQL databáze poskytují flexibilitu a výkon pro moderní aplikace, které vyžadují zpracování velkých objemů nestrukturovaných dat a rychlou odezvu.

> **Ukázka: NoSQL Document (JSON) databáze**

## Blockchain

Blockchain je decentralizovaný, distribuovaný digitální ledger, který zaznamenává transakce napříč mnoha počítači tak, aby žádný záznam nemohl být změněn zpětně bez změny všech navázaných bloků. Každý blok obsahuje kryptografický hash předchozího bloku, časové razítko a transakční data, což zajišťuje bezpečnost a neměnnost záznamů.

**Hlavní vlastnosti:**
- **Neměnnost:** Jakmile je transakce zaznamenána, nelze ji změnit.
- **Decentralizace:** Data jsou uložena na mnoha poččích (uzlech), což zvyšuje odolnost proti útokům a selháním.
- **Transparentnost:** Všechny transakce jsou veřejně dostupné a ověřitelné.

**Použití:**
- **Kryptoměny:** Bitcoin, Ethereum a další kryptoměny využívají blockchain pro bezpečné a transparentní transakce¹(https://cointelegraph.com/news/how-nfts-defi-and-web-3-0-are-intertwined).
- **Smart kontrakty:** Automatizované smlouvy, které se vykonávají samy při splnění určitých podmínek.
- **Supply chain management:** Sledování pohybu zboží a materiálů v dodavatelském řetězci.

### NFT (Non-Fungible Tokens)
NFT jsou jedinečné digitální tokeny, které představují vlastnictví konkrétního digitálního aktiva, jako jsou umělecká díla, sběratelské předměty nebo virtuální nemovitosti. Na rozdíl od kryptoměn, které jsou zaměnitelné (každý bitcoin je stejný jako jiný bitcoin), jsou NFT jedinečné a nelze je zaměnit.

**Hlavní vlastnosti:**
- **Jedinečnost:** Každý NFT je jedinečný a nelze jej zaměnit za jiný.
- **Vlastnictví:** NFT poskytují důkaz o vlastnictví digitálních aktiv.
- **Interoperabilita:** NFT mohou být obchodovány na různých platformách a tržištích.

**Použití:**
- **Umění a sběratelské předměty:** Digitální umění, hudba, videa.
- **Virtuální nemovitosti:** Vlastnictví virtuálních pozemků a nemovitostí v metaverzu.
- **Herní předměty:** Vlastnictví a obchodování s herními předměty a postavami.

### DeFi (Decentralized Finance)
DeFi je ekosystém finančních aplikací postavených na blockchainu, které umožňují poskytování finančních služeb bez potřeby tradičních finančních institucí. DeFi aplikace využívají smart kontrakty k automatizaci a zabezpečení transakcí.

**Hlavní vlastnosti:**
- **Decentralizace:** Finanční služby jsou poskytovány bez centrální autority.
- **Transparentnost:** Všechny transakce jsou veřejně dostupné a ověřitelné.
- **Interoperabilita:** DeFi aplikace mohou spolupracovat a integrovat se navzájem.

**Použití:**
- **Půjčky a úvěry:** Poskytování a přijímání půjček bez potřeby bank.
- **Obchodování:** Decentralizované burzy (DEX) umožňují obchodování kryptoměn bez prostředníků.
- **Spoření a investice:** Platformy pro spoření a investování s vyššími výnosy než tradiční bankovní produkty.

### Web3
Web3 je koncept nové generace internetu, který je postaven na decentralizovaných technologiích, jako je blockchain. Web3 se zaměřuje na vytvoření otevřeného a demokratického internetu, kde uživatelé mají kontrolu nad svými daty a identitou.

**Hlavní vlastnosti:**
- **Decentralizace:** Web3 aplikace běží na decentralizovaných sítích, což zajišťuje větší odolnost a bezpečnost.
- **Vlastnictví dat:** Uživatelé mají kontrolu nad svými daty a mohou je sdílet podle svého uvážení.
- **Interoperabilita:** Web3 aplikace mohou spolupracovat a integrovat se navzájem.

**Použití:**
- **Decentralizované aplikace (dApps):** Aplikace, které běží na blockchainu a nejsou kontrolovány žádnou centrální autoritou.
- **Decentralizované autonomní organizace (DAO):** Organizace řízené smart kontrakty, kde rozhodování probíhá demokraticky mezi členy.
- **Metaverse:** Virtuální světy, kde uživatelé mohou vlastnit a obchodovat s digitálními aktivy.
