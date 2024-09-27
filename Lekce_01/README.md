# 1. lekce: Základní koncepty návrhu cloudových řešení

## Abstrakce a jejich role v informatice
Zkuste si odpovědět na otázku: "**Co se stane, když zadáte adresu do prohlížeče a stisknete Enter?**".

Jak hluboko dokážete zajít a do jakých směrů? Internet a jeho protokoly? Operační systém a hardwarové přerušení z klávesnice? HTLM a Javascript? Servery a jejich technologie? Síťové připojení? Paměť nebo registry v procesoru?

Dokážete jít i obráceně a postavit nad tím hodnotu? Co třeba AI asistent, online textový editor, bankovnictví nebo online hry včetně těch high-endových servírovaných z cloudové grafiky?

Geny a přirozený výběr nedokáží změnit mozek za tak krátkou dobu jako je pár set let. Pokud unesete novorozeně z roku 1800 do současnosti bude dosahovat stejných výsledků a schopností jako děti z naší současnosti. Kdyby si Einstein a Newton prohodili mozky jako novorozenci, Einstein v době Newtonově by nikdy nevymyslel relativitu, protože by nemohl stavět na Maxwellovi, Lorentzovi nebo právě Newtonovi. Tomu trvalo 20 let přijít na teorii gravitace, která se dnes učí na střední škole během pár hodin a podle ní se počítalo přistání člověka na Měsíci.

Příklady abstrakce v informatice:
- Legendární [OSI model](https://en.wikipedia.org/wiki/OSI_model#Layer_architecture)
- Servisní modely [cloudových služeb](https://en.wikipedia.org/wiki/Cloud_computing#Service_models)

Cloudové služby lze z pohledu abstrakce rozdělit na:
- IaaS
- PaaS
- SaaS

## Vysoká dostupnost v cloudu
Vysoká dostupnost znamená, že aplikace je schopná být užitečná po co nejvyšší čas, nejlépe vždy. Vysoká dostupnost je ale vyvážena dalšími faktory jako jsou:
- Náklady (redundantní komponenty zvyšují cenu)
- Inovace, nové funkce, změny (každá změna znamená riziko)
- Bezpečnost (bezpečnostní opatření mohou zvyšovat zátěž a snižovat dostupnost - na druhou strnu úspěšný útok může znamenat výpadek)
- Složitost (a složitější systém je náchylnější k chybám)

Můžete si promyslet, jak namíchat jednotlivé aspekty pro různé scénáře. Určitě bude hodně rozdílů v implementaci kardiostimulátoru, vesmírného programu, mobilním bankovnictví, e-shopu nebo doporučovacím systému.

K tématu ladění systémů na vysokou dostupnost se vrátíme 12. lekci, až budeme rozebírat Site Reliable Engineering.

Základem vysoké dostupnosti je **redundance** a nejlépe tak, aby jednotlivé komponenty nesdíleli věci, které se mohou pokazit (**single point of failure**). Fyzická oddělenost je tak pro vysokou dostupnost zásadní a ruku v ruce s ní jde i logické oddělování (např. pokud je možné dělat nějaké změny a upgrady pouze na části zdrojů a ne na všech najednou, pomůže to vysoké dostupnosti). V Azure, AWS i Google se to dělá takhle:
- **Cloud provider** - Azure, AWS nebo Google mají velké množství různých regionů. Může vypadnout více regionů současně? Ano, byť je to málo pravděpodobné - může jít o nějaké selhání řízení sítě, problém autentizační služby nebo třeba nevhodná reakce na DDoS útok. Jedinou obranou je pak multi-cloud a to je dost drahé a nepraktické, ale třeba Netflix to dělá. 
- **Region** - geografická oblast s tím, že mezi regiony jsou obrovské vzdálenosti minimálně stovky kilometrů a provider nedělá změny v software ve všech regionech současně. Na druhou stranu vzdálenost znamená, že latence je vysoká a pro většinu aplikací s potřebou rozumného výkonu není vhodné provádět synchronní replikaci mezi regiony. Může region, který je složený z mnoha datových center a zón dostupnosti někdy selhat? Ano, byť to je opět málo pravděpodobné. Typicky půjde o nějakou softwarovou chybu v control plane, síťové problémy nebo DDoS. Mít schopnost využít více než jeden region je tak důležitá zejména pro obnovu v případě nějaké velké havárie celého regionu. 
- **Zóna dostupnosti** - v rámci regionu jsou obvykle 3 zóny dostupnosti (availability zone), které ale sami o sobě jsou souborem několika fyzických datových center, budov. Zóny nesdílí komponenty jako je chlazení, napájení nebo propojení a každá zóny má všechny tyto komponenty svoje a navíc redundantní (dva přívody ze dvou zdrojů, dvě chladící jednotky apod.). Může zóna dostupnosti selhat? Ano, a už jde o riziko, které zanedbatelné není. Často jde o nějakou nešťastnou souhru okolností, kdy například selže jedno chlazení v důsledku opotřebení, v ten okamžik vypadne napájení a protože do generátoru udeřil blesk, nenaběhne na plné kapacitě a protože všechny systémy se restartují a dělají opravy, generují takovou zátěž, že to napájení neutáhne a selže znovu (to jsem si vymyslel, ale je to typicky něco takhle nepravděpodobného, ale možného). Protože zóny jsou do 2 ms latence od sebe můžeme použít synchronní replikaci a získat tak redundanci bez ztráty dat a s téměř nulovým výpadkem dostupnosti.
- **Placement groups** - v rámci jedné zóny se pořád můžete vyskytovat v různých budovách a jsou situace, kdy potřebujete co nejnižší latenci a to i na úkor dostupnosti (třeba výpočetní clustery). Provideři obvykle umožňují umístit vaše compute instance blíž k sobě - jedno DC, jeden rack apod.Pravděpodobnost, že vám umřou všechny instance v placement group najednou, není nízká a vůbec se to nehodí pro aplikace s potřebou velmi vysoké dostupnosti.

Tohle všechno má vliv na aplikační a datovou architekturu a není to magie, neděje se to samo a zadarmo. K tomu se v kurzu několikrát vrátíme.

Míra složitosti co zbývá na vás hodně záleží na tom, jak abstrahovanou službu potřebujete. U IaaS máte jen infrastrukturu a je na vás ošetřit software tak, aby to fungovalo přes regiony nebo/a zóny dostupnosti. U PaaS ale často stačí vybrat správný tier a zmáčknout tlačítko.

## Cloud native
Tradiční IT se staví na principu "udělejme všechno pro to, aby k chybám nedocházelo" (maximalizace MTBF - Mean Time Between Failures). Moderní přístup se daleko víc zaměřuje na "udělejme všechno pro to, abychom se z chyb vždy dostali co nejrychleji" (minimalizace MTTR - Mean Time To Recovery). To znamená, že se počítá s tím, že chyby se stávat budou a je lepší se na ně připravit a umět s nimi pracovat, než se snažit je předem všechny odstranit. O tom všem se budeme bavit v pozdějších lekcích o aplikační architektuře a SRE.

## Zálohování, Disaster Recovery, RTO a RPO
Pokud máte všechna data automaticky rozkopírovaná ve třech nezávislých budovách (zónách dostupnosti) a k tomu ještě další tři kopie v jiném regionu (tisíc kilometrů daleko), máte tím vyřešeno a zálohovat netřeba?

Co když se data poškodí chybou v aplikaci, kybernetickým útokem, poškozením celé služby nebo chybou administrátora? Je skvělé že máte data 6x, ale v takový okamžik máte 6x ty poškozená data. Zálohování je nejčastější způsob, jak se chránit před ztrátou dat (jsou i další, například immutable storage ala WORM nebo blockchain, ale o tom v jiné lekci).

Když data zmizí a já je obnovím ze zálohy, jak stará je? To je **Recovery Point Objective (RPO)** a jinak řečeno o množství dat vyjádřené v čase, které jsem ochoten ztratit. Proberme aspekty RPO, co znamená nízké RPO pro provoz a náklady a ne-černobíle scénáře (například ztráta dat v systému nemusí znamenat, že se nedají zpětně dohledat).

V nějaký okamžik se rozhodnu, že provedu obnovu, ale to může nějakou dobu trvat a v průběhu této doby systém stále neběží. To je **Recovery Time Objective (RTO)** a jinak řečeno čas, který jsem ochoten čekat na obnovu. Jaké jsou aspekty RTO, co ho ovlivňuje, jak se to projevuje v nákladech?

> **[Ukázka: tradeoff mezi RTO a RPO](rto_rpo.md)**

Zmiňme ještě termín **business continuity**, což je schopnost firmy pokračovat v činnosti i přes krizové situace. To zahrnuje i aspekty jako je komunikace, záchrana zaměstnanců, zajištění základních potřeb a další. Platí tedy i to, že při havárii IT systémů může být možné v byznysu pokračovat s jiným systémem (například psát si objednávky v restauraci na papír a zákazníkovi vystavit paragon ručně).


## Šifrování, klíče a confidential computing
- Encryption at rest
  - Symetrické zašifrování dat, typicky AES (vysoký výkon)
  - Data Encryption Key (DEK) - **symetrický** klíč použitý k zašifrování dat
  - Key Encryption Key (KEK) - **asymetrický** klíč použitý k zašifrování DEK (často RSA) a výsledný šifrovaný DEK je uložen spolu s daty
- Encryption in transit
  - Šifrování může probíhat na jedné i více vrstvách
    - L2, např. [MACsec](https://en.wikipedia.org/wiki/MACsec)
    - L3, např. [IPsec](https://en.wikipedia.org/wiki/IPsec)
    - L4, např. [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security)
  - Příklad TLS:
    - Asymetrická šifra na začátku komunikace pro výměnu symetrického klíče
    - Strany (mTLS) nebo alespoň server (častější) se prokazují certifikátem - server ukazuje svůj public klíč a že patří skutečně jemu prokazuje dalším asymetrickým ověřením od certifikační autority
    - V průběhu dohadování si vyjasní jaké budou používat protokoly a algoritmy také jeden druhému pošlou náhodná čísla
    - Klient vygeneruje návrh pro symetrický klíč pro šifrování (pre-master) a zašifruje ho public klíčem serveru (= pouze server ho umí rozšifrovat)
    - Obě strany vezmou pre-master key a zkombinují ho s náhodnými čísly, které si vyměnili dříve a tím vznikne session key - klíš pro asymetrické šifrování zbytku komunikace (např. AES)
- Encryption in use
  - [Confidential computing](https://en.wikipedia.org/wiki/Confidential_computing)
  - [Homomorphic encryption](https://en.wikipedia.org/wiki/Homomorphic_encryption)
  - [Secure Multiparty Computation](https://en.wikipedia.org/wiki/Secure_multi-party_computation)
  - [Differential privacy](https://en.wikipedia.org/wiki/Differential_privacy)

> **[Ukázka: TLS](tls.md)**

> **[Ukázka: Confidential Computing](confidential_computing.md)**

## Cloudová governance
Při adopci cloudu je často zásadní učinit dost rozhodnutí na začátku s ohledem na přístup ke cloudu, migrační a aplikační strategii, bezpečnost a regulatorní záležitosti a v neposlední řadě vybudovat tzv. "landing zones" pro jednotlivé aplikace, tedy základní pravidla hry a infrastruktura (řízení uživatelských přístupů, jmenná konvence a tagování, hybridní sítě, DNS, monitoring, logování, šifrování a další). Implementace jsou pro všechny tři velké cloudy specifické a nejsou předmětem našeho kurzu, byť většinu jejich architektonických principů probírat budeme. Ve všech případech celou strategii a best practices pro daný cloud najdete pod názvem **Cloud Adoption Framework**.