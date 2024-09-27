# Architektura aplikací a zpracování dat v cloudu
- [Architektura aplikací a zpracování dat v cloudu](#architektura-aplikací-a-zpracování-dat-v-cloudu)
- [Modul 1: Základní koncepty](#modul-1-základní-koncepty)
  - [1. lekce: Základní koncepty návrhu cloudových řešení](#1-lekce-základní-koncepty-návrhu-cloudových-řešení)
- [Modul 2: Compute](#modul-2-compute)
  - [2. lekce: Od VM k serverless](#2-lekce-od-vm-k-serverless)
  - [3. lekce: Orchestrace kontejnerů](#3-lekce-orchestrace-kontejnerů)
- [Modul 3: Networking](#modul-3-networking)
  - [4. lekce: Rozdělení zátěže a nabírání provozu](#4-lekce-rozdělení-zátěže-a-nabírání-provozu)
  - [5. lekce: Enterprise networking](#5-lekce-enterprise-networking)
- [Modul 4: Aplikační patterny](#modul-4-aplikační-patterny)
  - [6. lekce: Návrhové vzory moderních aplikací](#6-lekce-návrhové-vzory-moderních-aplikací)
  - [7. lekce: Monitoring moderních aplikací](#7-lekce-monitoring-moderních-aplikací)
- [Modul 5: Perzistentní vrstva](#modul-5-perzistentní-vrstva)
  - [8. lekce: Typy uložení dat v cloudu a výkonnostní aspekty](#8-lekce-typy-uložení-dat-v-cloudu-a-výkonnostní-aspekty)
  - [9. lekce: Redundance a distribuce dat, dostupnost vs. konzistence](#9-lekce-redundance-a-distribuce-dat-dostupnost-vs-konzistence)
- [Modul 6: Zpracování dat](#modul-6-zpracování-dat)
  - [10. lekce: Distribuované zpracování a analýza dat](#10-lekce-distribuované-zpracování-a-analýza-dat)
  - [11. lekce: Strojové učení](#11-lekce-strojové-učení)
- [Modul 7: Procesy a nasazování](#modul-7-procesy-a-nasazování)
  - [12. lekce: Infrastructure as Code a Site Reliability Engineering](#12-lekce-infrastructure-as-code-a-site-reliability-engineering)
  - [13. lekce: CI/CD a DevSecOps](#13-lekce-cicd-a-devsecops)
- [Modul 8: Představení vybraných závěrečných prací](#modul-8-představení-vybraných-závěrečných-prací)
  - [14. lekce: Představení vybraných závěrečných prací](#14-lekce-představení-vybraných-závěrečných-prací)


# Modul 1: Základní koncepty

## [1. lekce: Základní koncepty návrhu cloudových řešení](Lekce_01/README.md)
- IaaS vs. PaaS vs. SaaS a přemýšlení v abstrakcích
- Vysoká dostupnost a nasazení přes zóny dostupnosti (AZ)
- Zálohování a Disaster Recovery, koncept RTO a RPO a jak se tyto parametry projevují v nákladech
- Šifrování, klíče a confidential computing
- Cloudová governance 

# Modul 2: Compute

## [2. lekce: Od VM k serverless](Lekce_02/README.md)
- Virtuální stroje
- Phoenix servery a kontejnerizace
- Serverless
- Autoškálování - principy, reakční doba, náklady, triggery
- Embarrassingly parallel (např. rendering 3D animací, hledání života ve vesmíru, Monte Carlo) vs. HPC MPI workloady (molekulární dynamika, skládání proteinů, simulace fyzikálních systémů)
- Ekonomika cloudu - vypínání, rezervace, savings plány, spot instance

## [3. lekce: Orchestrace kontejnerů](Lekce_03/README.md)
- Desired state architektura
- Rychlokurz Kubernetes
- Vyšší míra abstrakce s kontejnery jako služba v cloudu (např. Azure Container Apps, AWS Fargate, Google Cloud Run)
- Aplikační platformy jako pomocníci pro kontejnery (např. DAPR, serverless bindings)

# Modul 3: Networking

## [4. lekce: Rozdělení zátěže a nabírání provozu](Lekce_04/README.md)
- L4 vs. L7 balancing pro regionální provoz
- DNS balancing pro globální provoz
- Globálně distribuované řešení (dynamická CDN) pro globální provoz
- Role API managementu a jeho srovnání s reverse proxy řešením
- Hloupé, rychlé a kompatibilní trubky vs. chytré sítě (výhody a nevýhody například service mesh pro kontejnery)

## [5. lekce: Enterprise networking](Lekce_05/README.md)
- Privátní sítě v cloudu a napojení na on-premises přes VPN, SD-WAN nebo privátní linky (leased line - MPLS)
- Hybridní DNS služby
- Připojení platformních služeb do privátní sítě
- Hub-and-spoke topologie a centrální firewall

# Modul 4: Aplikační patterny

## [6. lekce: Návrhové vzory moderních aplikací](Lekce_06/README.md)
- Microservices
- Choreografie vs. orchestrace
- Fasáda a správa API
- Asynchronní architektura - competing consumers, event sourcing
- CQRS, saga pattern
- Zero-trust a identity, autentizace a autorizace v aplikacích (OAuth, OIDC, mTLS, verifiable credentials)
- Distribuované systémy (leader election, RAFT, Etcd, blockchain)

## [7. lekce: Monitoring moderních aplikací](Lekce_07/README.md)
- Push vs. Pull model
- Logování (například OpenSearch, nativní cloudové služby, OpenTelemetry)
- Metriky (například Prometheus a Grafana)
- Tracing (například OpenTelemetry a Jaeger nebo nativní cloudové služby na backendu)

# Modul 5: Perzistentní vrstva

## [8. lekce: Typy uložení dat v cloudu a výkonnostní aspekty](Lekce_08/README.md)
- Bloková storage vs. Souborová storage vs. Objektová storage vs. Databáze
- Mutable vs. immutable (append-only) perzistence a použití v různých systémech (Blob/S3, Kafka, ...)
- Bloková storage a výkonnostní charakteristiky (IOPS vs. throughput vs. latence)
- Relační databáze (MS SQL, PostgreSQL, ...)
- NoSQL databáze - document storage, key/value storage, graph storage (MongoDB, Cassandra, cloudové NoSQL)
- Blockchain

## [9. lekce: Redundance a distribuce dat, dostupnost vs. konzistence](Lekce_09/README.md)
- PACELC (rozšíření CAP teorému) a redundantní či distribuovaná datová vrstva
- Laditelnost konzistence (silná vs. eventuální konzistence a polohy mezi tím)
- Dopady konzistence na výkon a cenu
- Vysoká dostupnost vs. Disaster Recovery

# Modul 6: Zpracování dat

## [10. lekce: Distribuované zpracování a analýza dat](Lekce_10/README.md)
- Oddělení dat od compute se Spark a Lakehouse architekturou (např. Databricks)
- Streaming data (microbatching, Spark Structured Streaming, Databricks Delta Live Tables)
- Požadavek na míru čerstvosti dat a její vliv na architekturu a cenu (od batch po near-real-time)

## [11. lekce: Strojové učení](Lekce_11/README.md)
- Příprava dat a feature engineering
- Základní procesy strojového učení
- MLops
- Využití hotových AI modelů ve vlastních aplikacích přes API

# Modul 7: Procesy a nasazování

## [12. lekce: Infrastructure as Code a Site Reliability Engineering](Lekce_12/README.md) 
- Koncepty desired state, deklarativní vs. imperativní modely
- Srovnání nástrojů pro Infrastructure as Code (Terraform, Pulumi, Crossplane, nativní šablony a CDK)
- Klíčové koncepty pro udržitelné IaC (modularizace, abstrakce, Documentation as Code, smart defaults, verzování)
- Řízení konfigurací (Ansible, Chef, Saltstack, Puppet)

## [13. lekce: CI/CD a DevSecOps](Lekce_13/README.md)
- GitOps
- Automatizace a testování (na příkladu GitHub Actions)
- Základy DevSecOps, shift-left princip a integrace bezpečnosti do procesů vývoje a nasazování

# Modul 8: Představení vybraných závěrečných prací 

## [14. lekce: Představení vybraných závěrečných prací](Lekce_14/README.md) 

