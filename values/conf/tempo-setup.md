# Commission
aws s3 mb s3://tempo-bucket-67 --region us-east-1;

aws iam create-policy --policy-name TempoS3AccessPolicy --policy-document file://tempo-s3-policy.json

aws iam create-role --role-name TempoServiceAccountRole --assume-role-policy-document file://tempo-trust-policy.json

aws iam attach-role-policy --role-name TempoServiceAccountRole --policy-arn arn:aws:iam::686255956392:policy/TempoS3AccessPolicy

# Decommission

aws iam detach-role-policy --role-name TempoServiceAccountRole --policy-arn arn:aws:iam::686255956392:policy/TempoS3AccessPolicy

aws iam delete-role --role-name TempoServiceAccountRole

aws iam delete-policy --policy-arn arn:aws:iam::686255956392:policy/TempoS3AccessPolicy

aws s3 rb s3://tempo-bucket-67 --region us-east-1;

# Helm Chart (corrosponding values file present in values/conf/stable-values)

helm install tempo grafana/tempo-distributed -f tempo-dist-v1.yaml -n monitoring
