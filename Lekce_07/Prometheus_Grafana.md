# Prometheus and Grafana demo
1. Port-forward to one of prom-demo pods and see root of API and than /metrics to discuss Prometheus format
2. Port-forward to Prometheus UI service on port 9090 and try few queries:
   - up
   - starlette_requests_total
   - starlette_requests_total{path="/"}
   - sum by (path) (starlette_requests_total)
   - rate(starlette_requests_total[1m])
   - histogram_quantile(0.95, sum(rate(starlette_request_duration_seconds_bucket[1m])) by (le))
3. Port-forward to Grafana UI service on port 3000 and get login from prometheus-operator-grafana secret. Add starlette_requests_total to see ever increasing total line chart, then add rate.