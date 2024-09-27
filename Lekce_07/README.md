# 7. lekce: Monitoring moderních aplikací
Monitoring moderních aplikací je klíčový pro zajištění jejich spolehlivosti, výkonu a bezpečnosti. Existují tři základní kategorie monitoringu, které poskytují různé pohledy na stav a chování aplikací: **logy**, **metriky** a **traces**.

1. **Logy**:
   Logy jsou textové záznamy, které aplikace generují během svého běhu. Obsahují podrobné informace o událostech, chybách a dalších důležitých akcích. Analýza logů umožňuje identifikovat a řešit problémy, sledovat bezpečnostní incidenty a auditovat činnost aplikace.

2. **Metriky**:
   Metriky jsou číselné údaje, které kvantifikují různé aspekty výkonu aplikace, jako je využití CPU, paměti, počet požadavků za sekundu nebo doba odezvy. Metriky poskytují přehled o celkovém zdraví aplikace a umožňují sledovat trendy a detekovat anomálie.

3. **Traces**:

Proč je důležité soustředit se na aplikační monitoring?

V praxi se často stává, že se týmy zaměřují především na monitoring infrastruktury a metriky jako je využití CPU nebo paměti. I když jsou tyto metriky důležité, samotné nestačí k zajištění optimálního výkonu a spolehlivosti aplikací. Zde jsou důvody, proč je zásadní soustředit se spíše na aplikační monitoring:

1. **Pochopení uživatelského zážitku**:
   Díky aplikačnímu monitoringu lze rychleji identifikovat a diagnostikovat problémy, které ovlivňují výkon aplikace. Logy a traces umožňují detailní analýzu chyb a úzkých míst, což vede k rychlejšímu řešení incidentů.

3. **Optimalizace výkonu aplikace**:
   Aplikační monitoring umožňuje sledovat a analyzovat výkon aplikace v reálném čase. To pomáhá identifikovat oblasti, které vyžadují optimalizaci, a zajišťuje, že aplikace běží efektivně i při vysoké zátěži.

4. **Proaktivní přístup k údržbě**:
   S aplikačním monitoringem mohou týmy předvídat a předcházet problémům dříve, než ovlivní uživatele. Analýza trendů a anomálií umožňuje proaktivní údržbu a zlepšuje celkovou stabilitu aplikace.

5. **Lepší rozhodování**:
   Data získaná z aplikačního monitoringu poskytují cenné informace pro rozhodování o vývoji a úpravách aplikace. Pomáhají prioritizovat úkoly a zaměřit se na oblasti, které mají největší dopad na uživatele.

# Logy
1. **Zdroj logů**:
   Logy mohou být generovány přímo aplikací pomocí SDK nebo knihoven, které logují události, chyby a další důležité informace. Příklady zahrnují Log4j pro Javu nebo Serilog pro .NET. Často je však potřeba pomocník, který logy sbírá ze souborů nebo obrazovky. Mezi populární nástroje patří:
   - **SDK v aplikaci**: Knihovny a SDK, které umožňují generovat logy přímo z aplikace a posílat je na backend či collector po síti
   - **Logstash**: Nástroj pro sběr, transformaci a odesílání logů.
   - **FluentD**: Open-source nástroj pro sběr a přenos logů.
   - **FluentBit**: Lehčí verze FluentD, optimalizovaná pro nízkou spotřebu zdrojů.
   - **Filebeat**: Lehké řešení pro sběr a odesílání logů do Elasticsearch nebo Logstash.

2. **Sběr, filtrování a transformace logů**:
   Tento krok zahrnuje sběr logů z různých zdrojů, jejich filtrování a transformaci před uložením. Často se používají stejné nástroje jako v předchozím kroku, ale s různými konfiguracemi pro filtrování a transformaci dat. Typicky jde například o kolektor na úrovni Kubernetes clusteru. Příklady zahrnují:
   - **Logstash**: Může být nakonfigurován pro filtrování a transformaci logů, například parsování JSON nebo spojování více řádků do jednoho.
   - **FluentD**: Podobně jako Logstash, může provádět různé transformace logů a filtrování.
   - **FluentBit**: Lehčí verze FluentD, vhodná pro prostředí s omezenými zdroji a ideální pro svět cloud native (je součást CNCF).
   - **Filebeat**: Může být nakonfigurován pro sběr logů a jejich odesílání do Logstash nebo Elasticsearch, kde probíhá další zpracování.

3. **Ingestion pipeline a databáze na backendu**:
   Logy jsou obvykle ukládány v databázích, které jsou optimalizovány pro rychlé zápisy a dotazy. Tyto databáze jsou často append-only, což znamená, že data jsou pouze přidávána a nejsou měněna. To zajišťuje integritu a výkon při vysokém objemu dat. Součástí bývá i ingestion pipeline, škálovatelné řešení pro příjem a zpracování logů před tím, než se uloží. Příklady backend řešení zahrnují:
   - **Elasticsearch**: Vysoce výkonná vyhledávací a analytická databáze.
   - **Loki**: Systém pro ukládání logů, optimalizovaný pro nízké náklady na úložiště.
   - **Azure Monitor**: Služba pro monitorování a analýzu logů v Azure. Jako databázi používá Azure Data Explorer, která je zaměřená na částečně strukturovaná data s důrazem na ad-hoc query (ideální například i pro SIEM řešení, využívá to Microsoft Sentinel)
   - **AWS CloudWatch Logs**: Služba pro sběr a analýzu logů v AWS.
   - **Google Cloud Logging**: Služba pro sběr a analýzu logů v Google Cloud.

4. **Vizualizace a alertování**:
   Nad uloženými logy je potřeba mít nástroje pro vizualizaci a alertování, které umožňují rychle identifikovat problémy a reagovat na ně. Příklady nástrojů zahrnují:
   - **Kibana**: Nástroj pro vizualizaci dat uložených v Elasticsearch.
   - **Grafana**: Flexibilní nástroj pro vizualizaci metrik a logů, podporující různé backendy včetně Loki a Elasticsearch.
   - **Prometheus Alertmanager**: Nástroj pro alertování na základě metrik a logů.
   - **Azure Monitor Alerts**: Služba pro vytváření a správu upozornění v Azure Monitor.

   **Dotazovací jazyky**:
   - **Lucene Query Language**: Používá se v Elasticsearch a Kibana pro vyhledávání a filtrování dat. Je velmi výkonný a umožňuje složité dotazy.
   - **Kibana Query Language (KQL)**: Jednodušší a uživatelsky přívětivější jazyk pro dotazování v Kibana. Umožňuje rychlé a intuitivní vyhledávání.
   - **Kusto Query Language (KQL)**: Používá se v Azure Monitor, Azure Data Explorer, Sentinel a Defender nástrojích. Je navržen pro analýzu velkých objemů dat a umožňuje složité dotazy a agregace.

> **[Ukázka: Elastic a Kibana](Elastic_Kibana.md)**

# Metriky

## Pull model
V pull modelu sběru metrik se monitorovací systém (např. Prometheus) pravidelně dotazuje na metriky z jednotlivých aplikací nebo služeb. Aplikace musí vystavit endpoint (např. HTTP endpoint), ze kterého může monitorovací systém metriky načítat.

**Výhody:**
- **Kontrola nad dotazy**: Monitorovací systém má plnou kontrolu nad tím, kdy a jak často se metriky sbírají.
- **Jednoduchá konfigurace**: Aplikace nemusí být konfigurována pro odesílání metrik, stačí vystavit endpoint.
- **Škálovatelnost**: Snadno se škáluje, protože monitorovací systém může dotazovat velké množství endpointů bez nutnosti změn v aplikacích.

**Nevýhody:**
- **Zátěž na aplikaci**: Aplikace musí být schopna odpovídat na dotazy na metriky, což může zvýšit její zátěž.
- **Komplexita sítě**: V distribuovaných systémech může být složité zajistit, aby monitorovací systém měl přístup ke všem endpointům.

## Push model
V push modelu aplikace nebo služby pravidelně odesílají metriky do centrálního sběrače (např. Graphite, InfluxDB). Aplikace musí být konfigurována tak, aby metriky odesílala na specifikovaný endpoint.

**Výhody:**
- **Nízká zátěž na aplikaci**: Aplikace pouze odesílá metriky, nemusí odpovídat na dotazy.
- **Flexibilita**: Aplikace může odesílat metriky různým sběračům nebo do různých systémů.
- **Jednoduchost sítě**: Není potřeba, aby monitorovací systém měl přístup ke všem aplikacím, což zjednodušuje síťovou konfiguraci.

**Nevýhody:**
- **Komplexita konfigurace**: Aplikace musí být konfigurována pro odesílání metrik, což může být složité v prostředích s mnoha různými aplikacemi.
- **Ztráta metrik**: Pokud dojde k výpadku sběrače nebo sítě, metriky mohou být ztraceny, pokud nejsou správně bufferovány.

## Příklady řešení
- **Prometheus**: Open-source monitoringový nástroj s podporou pull modelu a bohatými možnostmi dotazování a vizualizace metrik.
- **Grafana**: Nástroj pro vizualizaci metrik a logů, který podporuje různé backendy včetně Prometheus, InfluxDB a Loki.
- **InfluxDB**: Časová databáze optimalizovaná pro ukládání a dotazování metrik.
- **Azure Monitor Metrics**: Služba pro sběr, ukládání a vizualizaci metrik v Azure.
- **AWS CloudWatch Metrics**: Služba pro sběr a vizualizaci metrik v AWS.
- **Google Cloud Monitoring**: Služba pro sběr a vizualizaci metrik v Google Cloud.
- **Datadog**: Komplexní platforma pro monitorování aplikací, která podporuje různé zdroje metrik a logů.
- **New Relic**: Platforma pro monitorování výkonu aplikací s podporou metrik, logů a traces.
- **Mimir od Grafana**: Backend pro metriky se sběrem přes Prometheus instrumentaci

> **[Ukázka: Prometheus a Grafana](Prometheus_Grafana.md)**

# Traces
## Co jsou traces?
Traces sledují cestu jednotlivých požadavků napříč různými službami a komponentami aplikace. Umožňují detailní pohled na to, jak požadavky procházejí systémem, a pomáhají identifikovat úzká místa a optimalizovat výkon. Traces se skládají z jednotlivých spanů, které reprezentují konkrétní operace nebo úseky v rámci požadavku. V minulosti byla řada proprietárních řešení, ale dnes jděte cestou standardního OpenTelemetry.

## OpenTelemetry jako SDK vs. OpenTelemetry jako standard
**OpenTelemetry jako SDK**:
- OpenTelemetry poskytuje SDK pro různé programovací jazyky, které umožňují vývojářům instrumentovat jejich aplikace pro sběr metrik, logů a traces.
- SDK umožňuje manuální instrumentaci aplikací, což znamená, že vývojáři mohou explicitně definovat, které operace a události mají být sledovány.

**OpenTelemetry jako standard**:
- OpenTelemetry je standard pro sběr a export telemetrických dat, který sjednocuje různé API a SDK pod jednu střechu.
- Standardizuje způsob, jakým jsou metriky, logy a traces sbírány a exportovány, což usnadňuje integraci s různými nástroji a backendy.
- OpenTelemetry podporuje push model, kde instrumentované aplikace aktivně odesílají telemetrická data do OpenTelemetry Collector nebo přímo do observability backendu(https://betterstack.com/community/guides/observability/opentelemetry-vs-prometheus/).

## Standardizace logů a metrik
Kromě traces se OpenTelemetry snaží standardizovat i sběr logů a metrik:
- **Logy**: OpenTelemetry nevyžaduje specifické API nebo SDK pro logy, ale umožňuje automatickou korelaci existujících logů s traces pomocí kontextových identifikátorů (https://opentelemetry.io/docs/specs/otel/logs/).
- **Metriky**: OpenTelemetry poskytuje API a SDK pro sběr metrik, které mohou být exportovány do různých backendů pomocí standardizovaných protokolů (https://opentelemetry.io/docs/specs/otel/metrics/data-model/).

## Exportér, kolektor a backendy
**Exportér**:
- Exportér je komponenta, která odesílá telemetrická data z aplikace do OpenTelemetry Collector nebo přímo do observability backendu. Může tak například zajistit Prometheus formát - aplikace je instrumentovaná OT SDK, ale výstupy umí dát tak, že je Prometheus může sbírat.
- Příklady exportérů zahrnují OTLP (OpenTelemetry Protocol) exportéry, které podporují různé formáty jako HTTP/protobuf, HTTP/JSON a gRPC(https://opentelemetry.io/ecosystem/registry/?component=exporter&language=dotnet).

**Kolektor** (https://opentelemetry.io/docs/collector/):
- OpenTelemetry Collector je nástroj, který sbírá, zpracovává a exportuje telemetrická data do různých backendů.
- Kolektor může být nasazen jako samostatná služba a podporuje různé přijímače, procesory a exportéry pro flexibilní zpracování dat.

**Vizualizační nástroje a backendy**:
- **Jaeger**: Open-source nástroj pro distribuované trasování, který poskytuje bohaté vizualizace a analýzu traces(https://www.jaegertracing.io/).
- **Azure Application Insights**: Služba od Microsoftu pro monitorování aplikací, která podporuje sběr a analýzu metrik, logů a traces (https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview).
- **Dynatrace**: Komplexní platforma pro monitorování aplikací a infrastruktury s podporou pro OpenTelemetry(https://www.dynatrace.com/).
- **AppDynamics**: Řešení pro monitorování výkonu aplikací (APM), které poskytuje detailní pohled na výkon aplikací(https://www.appdynamics.com/).
- **Honeycomb**: Moderní observabilita, která kombinuje metriky, logy a traces pro rychlou analýzu a řešení problémů(https://www.honeycomb.io/).
- **Datadog**: Platforma pro monitorování a analýzu metrik, logů a traces s podporou pro OpenTelemetry(https://www.datadoghq.com/).
- **Elastic**: Elastic Observability poskytuje nástroje pro sběr, analýzu a vizualizaci metrik, logů a traces(https://www.elastic.co/).

## Instrumentace
(https://opentelemetry.io/docs/concepts/instrumentation/)

> **[Ukázka: OpenTelmetry](OpenTelemetry.md)**