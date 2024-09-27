# 2. lekce: Od VM k serverless

## Servery, kontejnery a bez-servery
Na tabuli si společně projdeme cestu z fyzických serverů k virtuálním strojům, kontejnerů a nakonec serverless funkcím. Pár podkladů najdete tady:
- [Virtual Machine](https://en.wikipedia.org/wiki/Virtual_machine)
- [Comparing Containers and Virtual Machines](https://www.docker.com/resources/what-container/)
- [Functions as a Service](https://en.wikipedia.org/wiki/Function_as_a_service)

Automatizovat instalaci fyzických serverů je náročné, ale možné (např. Metal-as-a-Service od Canonical nebo Pliant od IBM). V cloudu je ale bare metal (fyzické servery) služba, která je dost exotická a běžně se nepoužívá. Většinou minimem jsou virtualizované stroje. Ty lze s využitím cloudového API automatizovat velmi dobře. Ukážme si pár pokročilejších cloud-native principů práce s VM. Přestože jsou zmíněné techniky dobře funkční a cloudový poskytovatel právě tohle používá pro budování vyšších služeb nad tím (PaaS - například databázi jako služba), firemní klientela často provozuje VM "bare metal stylem", tedy stroj vytvoří a několik let ho oprašují (aktualizace apod.). Tento přístup je jistě v pořádku pro migraci tradičních aplikací nepřipravených na cloud, ale pro modernější věci bych doporučoval jít více cloud-native cestou (a možná nezůstat u VM viz dále).

> **[Ukázka: Green-Blue nasazení VM](vm_green_blue.md)**

Cloud-native použití VM je poměrně těžkopádné. Image jsou veliké, stroje pomalu startují a tak podobně. Řešení postavené na kontejnerech má mnoho zásadních výhod:
- Škálovatelné a odlehčené (= rychlá reakce na změny zátěže, plynulé a časté upgrady)
- Lepší využití zdrojů (= nižší náklady)
- Konzistence prostředí - kontejner je jednotkou výpočetního výkonu i jednotkou nasazení
- Snadnější nasazení (= rychlejší vývoj, méně výpadků)

Pro běh kontejnerů typicky použijete orchestrační nástroj jako je Kubernetes (probereme v příští lekci detailněji), ale čím dál častěji nad ním vystavenou více abstrahovanou (jednodušší na používání a spolehlivý provoz) platformu (Azure Container Apps, AWS Fargate, Google Cloud Run). Tyto platformy vám umožní nasadit kontejnerovou aplikaci bez nutnosti spravovat orchestraci. Na krajní části je pak serverless, kde už vůbec nemusíte řešit infrastrukturu a platíte jen za to, co skutečně spotřebujete.

> **[Ukázka: Kontejnery vs. Serverless](webapp_green_blue.md)**

## Autoškálování a jeho aspekty
Autoškálování je schopnost systému reagovat na změny zátěže a přizpůsobit se jim. Může být **vertikální** (přidání výkonu na jednom stroji) nebo **horizontální** (přidání dalších strojů). Horizontální škálování je typické pro cloud-native aplikace a je založeno na tom, že aplikace je schopná běžet na více instancích a je schopná si mezi sebou rozdělit práci. U mnoha databázových systémů, které nabízí vysoké garance konzistence, ale horizontální škálování není k dispozici (cenou za něj je obvykle snížení garancí konzistence - o těchto aspektech a NoSQL světě se budeme v kurzu bavit později).

Často má škálování několik vrstev, například:
1. Instance (kontejner) má rezervu, je schopen pojmout zvýšenou zátěž
2. V reakci na zátěž můžeme nastartovat další kontejnery
3. Pokud dojde místo v clusteru, musíme nastartovat další podkladové nody
4. Pokud už nemůžeme nebo nechceme škálovat v daném regionu či cloudu, můžeme zvýšit kapacitu jinde a posílat některé uživatele tam

Obvykle ty nižší vrstvy mají velmi krátkou reakční dobu, ty vyšší výrazně větší. Proto dává smysl mít nějakou rezervu jejímž cílem je ustát to, než naběhnou další zdroje. Nízká rezerva znamená nižší cenu, ale vyšší riziko. Spustit 100 instancí když potřebuji jednu má nesmírně malé riziko, ale obrovskou cenu.

Rozhodující je také architektura - asynchronní, událostně řízené řešení je pro autoškálování vhodnější. Aplikační architekturu budeme rozebírat později v kurzu.

V neposlední řadě nás zajímá trigger, podle čeho poznáme, že máme škálovat a jak to naladit. Kromě výpočetních workloadů není obvykle ideální sledovat jednoduše CPU, protože nemusí vypovídat o kvalitě služby pro uživatele. Lepší budou metriky jako je délka fronty nebo odezvy.

Poznamenejme ještě, že obvykle se soustředíme na škálování nahoru (jsme úspěšní, chodí nám lidi), což ovlivňuje naši top-line (prodáme víc). Škálování dolu je méně atraktivní, ale ovlivňuje naše náklady. Jít dolu ale může být těžší úloha, zejména u stavových komponent (např. databáze).

## Paralelizace aneb jak si vyrobit superpočítač (HPC)
Podívejme se na dva problémy:
- Předpovídání počasí je výpočetně velmi náročná disciplína, kdy chceme v krajním případě simulovat fyzikální chování každé molekuly vzduchu v atmosféře. Z praktických důvodů si spíše rozdělíme atmosféru do nějakých krychliček. Každá má na svých hranách a vnějších plochách nějaké vlastnosti (např. teplotu, tlak, vlhkost), které jsou výsledkem její interakce s okolím. My můžeme provést složitý výpočet toho, co se bude následně uvnitř krychličky dít a výsledkem bude nějaká změna na hranách a vnějších plochách. Každou kostičku můžeme počítat zvlášť, paralelně. Nicméně - ona je i nadále ovlivňována okolními a ty okolní ovlivňuje, takže nemá cenu počítat to na nějaké příliš dlouhé období. Výsledky z jednotlivých paralelně běžících úloh je potřeba si často vyměňovat a synchronizovat. 
- Rendering 3D filmu je rovněž nesmírně náročná úloha na výpočetní kapacitu. Každé políčko filmu je potřeba propočítat - zejména co se týká drah světla, stínů, odrazů a průhlednosti. Každé políčko je nezávislé na ostatních, takže je možné je počítat paralelně. Doba výpočtu záleží na složitosti scény, ale bývá obvykle několik minut na silné GPU, někdy i několik hodin.

Jedna úloha je tightly coupled, druhá embarassingly parallel. V prvním případě je potřeba synchronizace a komunikace mezi jednotlivými částmi, v druhém případě je možné jednotlivé části počítat nezávisle a výsledky následně jednoduše spojit. Na hodině proberme konsekvence z pohledu compute potřeb (zejména síťové propojení, latence, fyzická vzdálenost uzlů).

## Ekonomika cloudu z pohledu compute
Jednotkové náklady na vteřinu běhu vašeho kódu jsou rozhodně nejnižší v situaci, kdy se vezmete pořádný kus (například VM) a efektivita jeho zatížení bude čistě váš problém. Pokud zvolíte kontejnery jako služba, ztráty dané provozem orchestrační platformy, neobsazené zdroje ve VM, neoptimální rozložení workloadu a tak podobně jdou na bedra providera. U serverless je situace úplně extrémní. Váš kód je jednou za hodinu například spustí v reakci na nějakou událost a vy zaplatíte pouhou vteřinu jeho běhu. Overhead je obrovský a jde na bedra providera. Proto je VM v jednotkové ceně nejlevnější, ale vaše typická využitelnost jejích zdrojů bývá tak nízká, že se vám nevyplatí.

| Typ služby | Typická utilizace | 1 hodinu |
|------------|-------------------|---------|
| VM v 3y rezervaci        | 10%               | 0,0155410959 EUR    |
| VM         | 10%               | 0,04088 EUR    |
| Kontejner  | 50%               | 0,097056 EUR     |
| Serverless | 95%               | 0,108 EUR   |


Základní ceny compute v cloudu jsou účtovány obvykle v řádu vteřin či minut a jde o tzv. Pay-as-you-go (PAYG). Pokud tedy zdroje nepoužíváte, je dobré je vypnout (= přestat platit), ideálně tedy pokud místo jednoho velkého zdroje používáte několik menších instancí (typické pro kontejnery) a jejich počet přizpůsobujete zátěži. Pokud ale nějaký compute potřebujete dlouhodobě, provider vám za to dá nějakou formou slevu:
- Rezervace zdroje v závazku 1 nebo 3 roky s různou mírou flexibility. Na horní hranici flexibility jsou třeba Savings Plans (Azure, AWS), kde se zavazujete k spotřebě vyjádřené v penězích na vyjmenované compute služby libovolných SKU i regionů. Na druhém konci spektra jsou Reserverd Instance v krajním případě uzamčené na konkrétní SKU a region s platbou dopředu a tam je sleva největší.
- U Google jsou Committed Use Contracts (podobné výše zmíněným metodám) a také Sustained Use Discount (defacto snížení ceny pro stroj, který v daném měsíci už běžel dlouho).

**Příklad 1** 
Máte Kubernetes cluster na každém kontinentu, který škáluje podle toho, zda místní zákazníci spí nebo ne a to následujícím způsobem:
- V noci 8 core
- Od 9 ráno do 5 večer v pracovních dnech 16 core
- Zpracování dat přes víkend - 16 core na asi 4 hodiny v průběhu víkendu
- Nepředvídatelné špičky jsou obvykle v délce 1 hodina a je potřeba 32 core

Jak bychom tohle mohli nakoupit?
- Neflexibilní rezervované instance v počtu 3x 8 core v těch regionech (sleva např. 65%)
- Flexibilní řešení typu Savings Plans na například na 8 core, protože víceméně každou hodinu někde běží (sleva např. 30%)
- Zbytek je špatně předvídatelný a je lepší ho pokrýt z PAYG bez slevy

**Příklad 2**
Máte farmu virtuálních desktopů pro zaměstnance a tady jsou potřeby z hlediska výkonu:
- Vždy (ve dne i v noci) 8 core
- 20h v pracovních dnech a 10h o víkendu 32 core
- 6h v pracovní dny 48 core
- 1h v pracovní dny v největší špičce 64 core

Na co si koupit rezervovanou instanci bude záležet na slevě (počítejme pro zjednodušení měsíc co má 28 dní):
- 8 core si koupíme určitě, potřebujeme trvale
- Dalších 24 core potřebujeme 20*20+10*8 = 480h měsíčně z 672h, tedy při slevě alespoň 28,6% a to určitě dostaneme, takže jdeme do rezervace (a nemusíme stroje vůbec vypínat)
- Dalších 16 core potřebujeme 6*20 = 120h měsíčně z 672h, tedy sleva by musela být 82% - to už pravděpodobně bude víc, než provider nabízí
- Dalších 16 core na špičky potřebujeme jen 20h měsíčně, tam určitě bude mnohem levnější jet v PAYG, zapínat stroje jen podle potřeby

