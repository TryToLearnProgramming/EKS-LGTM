# Commission
aws s3 mb s3://loki-chk-67 --region us-east-1; aws s3 mb s3://loki-rul-67 --region us-east-1

aws iam create-policy --policy-name LokiS3AccessPolicy --policy-document file://loki-s3-policy.json

aws iam create-role --role-name LokiServiceAccountRole --assume-role-policy-document file://trust-policy.json

aws iam attach-role-policy --role-name LokiServiceAccountRole --policy-arn arn:aws:iam::686255956392:policy/LokiS3AccessPolicy

# Decommission

aws iam detach-role-policy --role-name LokiServiceAccountRole --policy-arn arn:aws:iam::686255956392:policy/LokiS3AccessPolicy

aws iam delete-role --role-name LokiServiceAccountRole

aws iam delete-policy --policy-arn arn:aws:iam::686255956392:policy/LokiS3AccessPolicy

aws s3 rb s3://loki-chk-67 --region us-east-1; aws s3 rb s3://loki-rul-67 --region us-east-1



# Helm Chart

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install --values loki-values.yaml loki grafana/loki -n monitoring


# secrets create
kubectl create secret generic canary-basic-auth --from-literal=username=loki --from-literal=password=password123 -n monitoring

kubectl create secret generic loki-basic-auth --from-file=.htpasswd -n monitoring