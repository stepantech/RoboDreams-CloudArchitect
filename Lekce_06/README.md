# 6. lekce: Návrhové vzory moderních aplikací

## Mikroslužby
[Microservices](https://learn.microsoft.com/en-us/azure/architecture/microservices/)

## Fasáda a správa API
[Backend for Frontend](https://learn.microsoft.com/en-us/azure/architecture/patterns/backends-for-frontends)

> **[Ukázka: API Management](apim.md)**

## Asynchronní architektura
[Pub/sub](https://learn.microsoft.com/en-us/azure/architecture/patterns/publisher-subscriber)
[Competing consumers](https://learn.microsoft.com/en-us/azure/architecture/patterns/competing-consumers)
[Async request reply](https://learn.microsoft.com/en-us/azure/architecture/patterns/async-request-reply)

> **[Ukázka: Competing consumers](competing_consumers.md)**

## Choreografie vs. orchestrace
[Choreography](https://learn.microsoft.com/en-us/azure/architecture/patterns/choreography)

> **[Ukázka: Choreografie vs. orchestrace](orchestration_vs_choreography.md)**

## Event sourcing
[Event sourcing](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing)

## CQRS, saga pattern
[Compensating transaction](https://learn.microsoft.com/en-us/azure/architecture/patterns/compensating-transaction)
[Saga pattern](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/saga/saga)
[CQRS](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs)

## Zero-trust a identity, autentizace a autorizace v aplikacích
### Rozdíl mezi autentizací a autorizací
- **Autentizace** je proces ověření identity uživatele. Zahrnuje kontrolu, zda uživatel je tím, za koho se vydává, například pomocí hesla, biometrických údajů nebo dvoufaktorové autentizace.
- **Autorizace** je proces určení, jaké zdroje nebo služby může autentizovaný uživatel používat. Zahrnuje přidělování oprávnění a přístupových práv na základě rolí nebo politik. Základní způsoby řízení přístupu jsou role-based access control (RBAC) a attribute-based access control (ABAC) a Discretionary Access Control (DAC).

### Zero Trust
- **Zero Trust** je bezpečnostní model, který předpokládá, že žádný uživatel nebo zařízení není automaticky důvěryhodné, a to ani uvnitř sítě. Každý přístupový požadavek je ověřován, autorizován a šifrován, bez ohledu na to, odkud pochází.

### Vývoj ověřování
- **Username/Password lokálně**: Na začátku se používala jednoduchá uživatelské jména a hesla uložená lokálně v každém systému (osobní počítač, databázový server, aplikace). Tento přístup byl snadný, ale měl mnoho bezpečnostních nedostatků, jako je snadné prolomení hesel a nemožnost centrální správy.
- **Centrální adresář**: S rostoucím počtem uživatelů a zařízení se objevila potřeba centrálního adresáře, který by umožňoval správu uživatelských účtů a přístupových práv z jednoho místa. To vedlo k vývoji systémů jako LDAP (Lightweight Directory Access Protocol).
- **Kerberos**: Kerberos byl vyvinut pro řešení problémů s bezpečností a správou autentizace v síťovém prostředí. Používá lístky (tickets) pro ověření identity a zajišťuje, že hesla nejsou přenášena po síti v čitelné podobě.
- **SAML (Security Assertion Markup Language)**: S rostoucí potřebou federované autentizace mezi různými organizacemi a službami vznikl SAML, aby nebylo například nutné pro konzumaci SaaS produktu třetí strany zpřístupnit pro ně váš adresář. Umožňuje výměnu autentizačních a autorizačních dat mezi stranami, což usnadňuje jednotné přihlášení (SSO) a spolupráci mezi různými doménami.
- **OAuth 2.0 a OpenID Connect**: SAML se ukázal jako nedostatečný pro moderní webové a mobilní aplikace, které potřebovaly nejen autentizaci, ale i autorizaci přístupu k uživatelským datům. OAuth 2.0 umožňuje aplikacím přístup k uživatelským datům bez sdílení hesel, zatímco OpenID Connect rozšiřuje OAuth 2.0 o autentizační funkce. Jako příklad si představme například aplikaci pro hledání shod v časových možnostech pro schůzku, která potřebuje přístup k vašemu kalendáři, ale nesmí mít váš login nebo tam provádět něco jiného.

### Základní OAuth 2.0 flow a jejich použití
- **Authorization Code Flow**: Používá se pro serverové aplikace. Uživatel se přihlásí a získá autorizační kód, který aplikace vymění za přístupový token.
- **Implicit Flow**: Používá se pro klientské aplikace (např. SPA). Přístupový token je získán přímo bez výměny autorizačního kódu.
- **Client Credentials Flow**: Používá se pro server-to-server komunikaci. Aplikace získá přístupový token pomocí svých vlastních přihlašovacích údajů.

> **[Ukázka: Autentizace a autorizace](authn_authz.md)**

## Distribuované systémy
Distribuované systémy jsou systémy, ve kterých jsou komponenty umístěny na různých síťových uzlech, které spolu komunikují a koordinují své akce prostřednictvím zpráv. Tento přístup umožňuje škálovatelnost, odolnost proti chybám a lepší využití zdrojů.

### Leader Election
Leader election je proces, při kterém je v distribuovaném systému vybrán jeden uzel jako vůdce, který koordinuje činnosti ostatních uzlů. Tento proces je klíčový pro udržení konzistence a koordinace v systému. Leader election může zlepšit efektivitu a zjednodušit architekturu, ale také může zavést nové body selhání a škálovací omezení.

### Distribuovaný konsensus
Distribuovaný konsensus je mechanismus, který umožňuje uzlům v distribuovaném systému dosáhnout shody na hodnotě nebo stavu. Tento proces je nezbytný pro zajištění konzistence dat a správného fungování systému i při výpadcích některých uzlů. Mezi klíčové vlastnosti konsensuálních algoritmů patří:
- **Terminace**: Každý neporušený proces musí dospět k rozhodnutí.
- **Dohoda**: Všechny správné procesy musí souhlasit se stejnou hodnotou.
- **Integrita**: Pokud všechny správné procesy navrhnou stejnou hodnotu, musí se na této hodnotě shodnout

### Problém Byzantského generála
Byzantský problém popisuje situaci, kdy uzly v distribuovaném systému mohou selhat a poskytovat různé a potenciálně škodlivé informace ostatním uzlům. Tento problém je pojmenován podle byzantských generálů, kteří musí dosáhnout shody na společné akci, i když někteří z nich mohou být zrádci

### Algoritmy distribuovaného konsensu, které nemají byznatskou toleranci.
- **Paxos**: Rodina protokolů pro dosažení konsensu v síti nespolehlivých procesorů. Paxos zajišťuje bezpečnost (konzistenci) i při výpadcích některých uzlů.
- **RAFT**: Konsensuální algoritmus, který je navržen jako srozumitelnější alternativa k Paxosu. RAFT dosahuje konsensu prostřednictvím volby vůdce a replikace logů.

### Algoritmy pro řešení byzantského problému
- **Byzantine Fault Tolerance (BFT)**: Algoritmus, který umožňuje dosažení konsensu i v přítomnosti byzantských chyb. BFT vyžaduje, aby více než dvě třetiny uzlů byly spolehlivé.
- **Practical Byzantine Fault Tolerance (PBFT)**: Efektivnější varianta BFT, která je používána v privátních blockchainových systémech. PBFT pracuje na principu vícefázového hlasování.
- **Proof of Work (PoW)**: Proslavené použitím v blockchain síti Bitcoin. Tento algoritmus vyžaduje, aby uzly (minery) řešily složité matematické problémy, což vyžaduje značné množství výpočetního výkonu a energie. PoW zajišťuje, že útoky na síť jsou ekonomicky nevýhodné, protože náklady na útok by převýšily potenciální zisky.
- **Proof of Stake (PoS)**: Proslavené mnoha blockchain sítěmi, například Etherum v minulosti přešlo z PoW na PoS. Tento algoritmus vybírá validátory na základě množství kryptoměny, kterou vlastní a jsou ochotni zastavit jako záruku. PoS je energeticky úspornější než PoW a snižuje riziko centralizace, protože nevyžaduje specializovaný hardware.