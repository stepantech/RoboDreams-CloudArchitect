# ElasticSearch s Kibana
1. Přesměrujte port na službu Kibana UI na portu 5601 a přihlaste se na `https://localhost:5601/` s uživatelem elastic a heslem z tajného klíče `myelastic-es-elastic-user`. Prozkoumejte uživatelské rozhraní a zkuste vytvořit nějaké vizualizace a dashboardy.
2. Přidejte rozšíření Kubernetes a upravte soubor následovně
   - Změňte output in configmap
    outputs:
      default:
        type: elasticsearch
        hosts:
          - 'https://myelastic-es-http.default.svc.cluster.local:9200'
        username: "${ES_USERNAME}"
        password: "${ES_PASSWORD}"
        preset: balanced
        ssl:
          verification_mode: none

    - Změňte proměnné prostředí v daemonset, aby odrážely správné heslo
    - Zvyšte memory resource limits
