# 13. lekce: CI/CD a DevSecOps

## Continuous Integration a Continuous Deployment/Delivery

### Continuous Integration (CI)
Continuous Integration (CI) je praxe, která zahrnuje pravidelné integrace změn kódu do hlavního repozitáře. Každá změna je automaticky testována, což pomáhá rychle identifikovat a opravit chyby. CI zajišťuje, že kód je vždy v nasaditelném stavu, což zvyšuje kvalitu a stabilitu softwaru. Nástroje jako Jenkins, GitHub Actions nebo GitLab CI/CD jsou běžně používány pro implementaci CI.

### Continuous Deployment/Delivery (CD)
Continuous Deployment (CD) a Continuous Delivery (CD) jsou praxe, které rozšiřují CI o automatizované nasazení aplikace do produkčního prostředí. 

- **Continuous Delivery**: Zahrnuje automatizované nasazení do testovacího nebo staging prostředí, přičemž nasazení do produkce vyžaduje manuální schválení. To zajišťuje, že aplikace je vždy připravena k nasazení.
- **Continuous Deployment**: Jde o plně automatizovaný proces, kde každá změna, která projde testy, je automaticky nasazena do produkce. Tento přístup umožňuje rychlé a časté nasazování nových funkcí a oprav.

Oba přístupy zvyšují efektivitu a rychlost vývoje, snižují riziko chyb a zajišťují, že nové verze aplikace jsou rychle dostupné uživatelům.

## Základy DevSecOps

### Co je DevSecOps a proč je důležité
DevSecOps je přístup, který integruje bezpečnostní praktiky do celého životního cyklu vývoje softwaru, od plánování až po nasazení a provoz. Cílem je zajistit, aby bezpečnost byla nedílnou součástí vývojového procesu, nikoli dodatečným krokem. Tento přístup pomáhá identifikovat a řešit bezpečnostní problémy dříve, což vede k bezpečnějším a spolehlivějším aplikacím.

### Shift-left princip: Integrace bezpečnosti od začátku
Shift-left princip znamená posunout bezpečnostní aktivity co nejdříve do vývojového cyklu. Místo toho, aby se bezpečnostní testy prováděly až na konci, jsou integrovány do všech fází vývoje. To umožňuje rychlejší identifikaci a opravu bezpečnostních chyb, což snižuje náklady a rizika spojená s pozdějšími opravami.

### Nástroje a techniky pro DevSecOps
DevSecOps využívá různé nástroje a techniky k zajištění bezpečnosti v celém vývojovém procesu. Mezi klíčové nástroje patří:

- **Statická analýza kódu**: Analýza zdrojového kódu bez jeho spuštění, která pomáhá identifikovat potenciální bezpečnostní chyby a zranitelnosti.
- **Dynamická analýza kódu**: Testování aplikace během jejího běhu, které simuluje útoky a identifikuje zranitelnosti v reálném čase.
- **Automatizované bezpečnostní testy**: Integrace bezpečnostních testů do CI/CD pipeline, které automaticky testují aplikaci při každém nasazení nebo změně kódu.

### Statická analýza kódu
Statická analýza kódu je technika, která analyzuje zdrojový kód bez jeho spuštění. Pomocí nástrojů jako SonarQube nebo GitHub Advanced Security lze identifikovat potenciální bezpečnostní chyby, jako jsou SQL injection, XSS nebo nesprávné používání kryptografických funkcí. Tato analýza pomáhá vývojářům opravit chyby ještě před tím, než se kód dostane do produkce.

### Dynamická analýza kódu
Dynamická analýza kódu zahrnuje testování aplikace během jejího běhu. Nástroje jako OWASP ZAP nebo Burp Suite simulují útoky na aplikaci a identifikují zranitelnosti, které by mohly být zneužity útočníky. Tento typ analýzy je klíčový pro odhalení problémů, které nelze zjistit statickou analýzou.

### Automatizované bezpečnostní testy
Automatizované bezpečnostní testy jsou integrovány do CI/CD pipeline a provádějí se při každém nasazení nebo změně kódu. Tyto testy mohou zahrnovat jak statickou, tak dynamickou analýzu, a pomáhají zajistit, že každá verze aplikace je bezpečná. Nástroje jako  GitHub Actions umožňují snadnou integraci těchto testů do vývojového procesu.

> **[Ukázka: DevSecOps](DevSecOps.md)**

## GitOps
GitOps je moderní přístup k nasazování a správě aplikací, který využívá Git jako jediný zdroj pravdy. Tento přístup umožňuje automatizaci a zjednodušení procesů nasazování, což vede k vyšší spolehlivosti a konzistenci. Hlavní myšlenkou GitOps je, že veškeré změny v infrastruktuře a aplikacích jsou prováděny prostřednictvím Git repozitáře, což zajišťuje auditovatelnost a snadnou revertibilitu změn.

### Pull-based deployment
Klasické řešení je nasazovat tak, že CI/CD pipeline kontaktuje Kubernetes a pošle do něj instrukce (často přes Helm). Co kdyby ale cluster samotný měl schopnost doptávat se, co má dělat a toto místo pravdy byl Git? Naše CI/CD pipeline pak nasazuje tak, že zapíše nejnovější konfigurace a šablony do Gitu a o víc se nestará - Kubernetes clustery si to stáhnou svým tempem až se k tomu dostanou. Zejména pokud jich jsou tisíce a jde třeba o výdajové boxy dopravní společnosti a občasnými výpadky konektivity.

> **[Ukázka: ArgoCD](ArgoCD.md)**

### Výhody GitOps
- **Automatizace a konzistence**: Všechny změny jsou prováděny prostřednictvím Git, což zajišťuje konzistentní a opakovatelné nasazení.
- **Auditovatelnost**: Každá změna je zaznamenána v Git historii, což usnadňuje sledování a auditování změn.
- **Rychlejší zotavení**: V případě problémů je možné snadno vrátit změny zpět na předchozí verzi.
- **Bezpečnost**: GitOps umožňuje implementaci bezpečnostních kontrol přímo v CI/CD pipeline.

### Praktické příklady s využitím Kubernetes API
- **ArgoCD**: Nástroj pro kontinuální doručování, který umožňuje implementaci GitOps principů. 
- **Flux**: Další populární nástroj pro GitOps, který se integruje s Kubernetes a umožňuje automatizované nasazování.
- **Crossplane**: Nástroj pro deklarativní správu infrastruktury, který umožňuje vytváření a správu infrastrukturních zdrojů pomocí Kubernetes API, takže je možné využít GitOps principy i pro infrastrukturu.
- **Terraform Cloud Operator**: Operátor pro Kubernetes, který umožňuje vytváření a správu Terraform konfigurací pomocí Kubernetes API.