# 4. lekce: Rozdělení zátěže a nabírání provozu
Aplikace určená pro uživatele je k ničemu, pokud ten se k ní nedostane. Protože z důvodu rozdělení zátěže, škálování, redundance, disaster recovery nebo optimalizace výkonu a blízkosti poběží aplikace ve více než jedné instanci, musíme vyřešit jak provoz uživatelů nabírat, směrovat a doručovat k našemu běžícímu kódu (například na instanci kontejneru).

Postup z pohledu klienta (např. prohlížeč vašeho počítače):
1. Zadáme URL do adresního řádku
2. DNS dotaz do Internetu s žádostí o překladu jména na IP adresu
3. DNS odpověď nemusí přijít hned napoprvé, protože může jít o řetězec "přezdívek" - např. nejakadomena.cz -> CNAME balancer.jinadomena.cz -> CNAME westeurope.mojeappka.nejakadomena.cz -> A 1.2.3.4
4. Prohlížeč se pokusí navázat TCP spojení na IP adresu
5. Pokud jde o HTTPS,  dojde k navázání TLS (server hello, client hello atd.- to už známe)
6. V sestaveném TLS tunelu je přes HTTP protokol pošle například obsah stránky

Základní 3 druhy load balancerů:
- **L4 balancer** - pracuje na úrovni IP adres a portů, nevidí do obsahu paketů, nerozumí šifrování ani URL cestám, neumožňuje chytřejší směrování nebo držení rozhodnutí a vybrané cestě (session persistence) na základě něčeho jiného, než IP a portu. Obvykle je jednoduchý = vysoký výkon, nížká cena.
- **L7 balancer** neboli reverse proxy - klient nekomunikuje vůbec se serverem napřímo, TCP, TLS i HTTP komunikace je mezi klientem a proxy a ta si vytváří svojí session s backend servery. Proxy přehazuje komunikaci mezi tunelem ke klientovi a tunelem k serveru, rozšifrovává komunikaci a může se rozhodovat i podle cookie, URL cesty, HTTP hlaviček, obsahu atd. Může přidávat například bezpečnostní vlastnosti, protože jako jediný vidí do provozu (Web Application Firewall), ale je nejnáročnější (= nejdražší).
- **DNS balancer** - nestojí v cestě komunikace, aplikuje se pouze na začátku procesu, kdy klient hledá IP k dané doméně. DNS balancer je chytrý DNS server, který může ve výsledku vrátit IP podle nějakého algoritmu (např. server, který je ke klientovi nejbližší funkční nebo má nejméně zátěže apod.). Není v cestě komunikace a je tak téměř zadarmo, ale po iniciálním rozhodnutí už nedokáže rychle reagovat na změny (např. pokud server vypadne a klient už byl na něj poslán).

Nejčastějším použitím je kombinace a distribuovanost. V živé lekci si probereme, ale v textu uveďme jednu z možností:
- Před instancemi v konkrétním cluster a regionu může být jednoduchý L4 balancer. Na konkrétním nodu nám má záležet co nejméně (bude dobré externalizovat state - viz aplikační část tohoto kurzu) a všechny jsou víceméně stejně daleko a mají stejný state. V cloudu je to takřka vždy nativní služba a používat jinou nedává smysl (např. Azure Load Balancer, AWS Elastic Load Balancer, Google Cloud Load Balancer).
- Před tímto regionálním L4 balancerem typicky bude L7 balancer, který přidá pokročilé možnosti směrování zejména podle URL (například nad stejnou doménou mít různé části API, statický obsah apod.) nebo hlavičky (typicky pro canary release, progressive delivery apod.). Někdy bude tento balancer plnit i bezpečnostní úlohu (WAF). Obvykle je rozumné použít nativní cloudovou službu (např. Azure Application Gateway, AWS Application Load Balancer, Google Cloud Load Balancer), ale často se používá třeba klasická F5 (jednotné řešení přes on-premise a cloud).
- Před těmito regionálními balancery bude globální balancer. Tradičně by šlo o DNS balancer, ale dnes čím dál častěji globálně distribuované L7 řešení obvykle označované jako dynamické CDN, Cloud WAF a tak podobně (např. Azure Front Door, Akamai, CloudFlare, Amazon CloudFront, Verizon Edgecast, Google Cloud CDN, Fastly, Imperva a další). Tyto globální řešení jsou rozprostřené po planetě (typicky nižší stovky POP lokalit, většinou včetně Prahy, Vídně, někdy Bratislavy)

> **[Ukázka: Load Balancing](lb.md)**

Ještě zmiňme, že v některých případech distribuovaných řešení jsou v POP lokalitách i možnosti provozovat komplexní logiku a to dokonce až na úroveň vlastního kódu. 

Na aplikační úrovni se v případě API (rozhranní pro komunikaci aplikačních komponent, například grafického uživatelského prostředí v mobilu či prohlížeči s různými backend službami) často používá API Management. Jde v zásadě o variaci na L7 balancing, o kterém jsme před chvílí mluvili, ale kromě směrování nebo bezpečnosti přidává další aplikačně specifické funkce. Může jít například o autentizaci a práci s tokeny, přízení přístupu, politiky pro užívání (například rate limit nebo monetizace), revize a verzování, převody formátů a manipulace s obsahem (např. konverze XML to JSON nebo SOAP do REST) a tal podobně.

> **[Ukázka: API Management](apim.md)**

Desítky let je v komunikací stále trvající dilema - chytré trubky a hloupé endpointy nebo naopak? Neboli má být komunikační infrastrukturu jednoduchá, levná, výkonná a kompatibilní a veškerá logika být v endpointech (takže ti musí být chytré) nebo naopak, tedy komunikační infrastruktura přináší pokročilou logiku (garantované doručení, přesměrování, circuit breaker a retry, šifrování, QoS - kvalita služby, frontování, buffering) a koncové body tak mohou být jednoduché?

Hloupé trubky, chytré endpointy - dobrým příkladem je vítězství Ethernetu nad vším ostatním (např. Fibre Channel, ATM, Token Ring). Jeho jednoduchost vedla na lepší kompatibilitu mezi výrobci a masivní nárůsty hrubého výkonu, ale endpointy potřebovaly složitější TCP/IP stack pro řízení spojení, spolehlivost, fragmentaci, reasembly, QoS a tak dále.

Chytré trubky, hloupé endpointy - dobrým příkladem ze současnosti je Service Mesh (např. Istio), kde aniž by o tom kontejnery potřebovaly vědět, síť jim zajišťuje šifrování, retry, circuit breaker, podrobný monitoring a tracing a tak podobně. 

