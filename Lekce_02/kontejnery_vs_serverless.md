# Kontejnery vs. Serverless
V tomto příkladu nasadíme jednoduchou webovou aplikaci na ToDo s následující architekturou:
- ToDo API s CRUD operacemi (výpis všech nebo jedné konkrétní položky, vytvoření, úprava, smazání)
- PostgreSQL databáze
- AI mikroslužba, která poslouchá na událost vytvoření ToDo a obohatí data o AI vygenerovanou motivační řeč
- React frontend

Toto nasedíme dvěma způsoby:
- Aplikační komponenty zabalíme do kontejneru a nasadíme pomocí Azure Container Apps
- Aplikační kód pošleme rovnou do serverless platformy Azure Functions pro mikroslužby a Azure Static Web Apps pro frontend