# ElasticSearch with Kibana
1. Port-forward to Kibana UI service on port 5601 and login to https://localhost:5601/ with elastic as user and password from myelastic-es-elastic-user secret. Explore the UI and try to create some visualizations and dashboards.
2. Add Kubernetes extension and modify file accordingly:
   - Change output in configmap
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

    - Change envs in daemonset to reflect correct password
    - Increate memory resource limits
