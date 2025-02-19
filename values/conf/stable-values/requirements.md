

helm upgrade loki grafana/loki -f loki-values.yaml -n monitoring

helm upgrade promtail grafana/promtail -f promtail-values.yml -n monitoring