Using Helm to install Mimir on EKS


# Commission
aws s3 mb s3://mimir-bucket-67 --region us-east-1; aws s3 mb s3://mimir-bucket-blocks-67 --region us-east-1;
aws iam create-policy --policy-name MimirS3AccessPolicy --policy-document file://mimir-s3-policy.json

aws iam create-role --role-name MimirServiceAccountRole --assume-role-policy-document file://mimir-trust-policy.json

aws iam attach-role-policy --role-name MimirServiceAccountRole --policy-arn arn:aws:iam::686255956392:policy/MimirS3AccessPolicy

# Decommission

aws iam detach-role-policy --role-name MimirServiceAccountRole --policy-arn arn:aws:iam::686255956392:policy/MimirS3AccessPolicy

aws iam delete-role --role-name MimirServiceAccountRole

aws iam delete-policy --policy-arn arn:aws:iam::686255956392:policy/MimirS3AccessPolicy

aws s3 rb s3://mimir-bucket-67 --region us-east-1;

