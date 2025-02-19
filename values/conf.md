kubectl create namespace monitoring

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install grafana grafana/grafana --namespace monitoring --create-namespace --values grafana-values.yaml
helm install loki loki-stack/loki --namespace monitoring --create-namespace --values loki-values.yaml
helm install tempo tempo-stack/tempo-stack --namespace monitoring --create-namespace --values tempo-values.yaml



In grafana you need X-Scope-OrgId in HTTP header value will be tenant - id auth enabled



http://loki-gateway.monitoring.svc.cluster.local/
http://prometheus-kube-prometheus-prometheus.monitoring.svc:9090