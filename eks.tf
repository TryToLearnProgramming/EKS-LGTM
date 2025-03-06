module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.26.0"


  cluster_name    = local.name
  cluster_version = local.cluster_version

  # cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    statefulset = {
      desired_size = 4
      min_size     = 4
      max_size     = 10

      labels = {
        role = "statefulset"
      }
      ami_type       = local.ami_type
      instance_types = local.instance_types
      capacity_type  = local.capacity_type

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 50
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      subnet_ids = [for az in ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}", "${data.aws_availability_zones.available.names[2]}"] : element(module.vpc.private_subnets, index(data.aws_availability_zones.available.names, az))]

      iam_role_additional_policies = {
        route53_policy = aws_iam_policy.route53_policy.arn
        s3_full_access_policy = aws_iam_policy.s3_full_access_policy.arn
      }
    }
  }

  tags = local.tags
}

# Output the EKS cluster ARN
output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = module.eks.cluster_arn
}

# Output the EKS cluster certificate authority data
output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster."
  value       = module.eks.cluster_certificate_authority_data
}

# Output the EKS cluster endpoint
output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server."
  value       = module.eks.cluster_endpoint
}

# Output the EKS cluster ID
output "cluster_id" {
  description = "The ID of the EKS cluster."
  value       = module.eks.cluster_id
}

# Output the EKS cluster name
output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

# Output the EKS cluster OIDC issuer URL
output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider."
  value       = module.eks.cluster_oidc_issuer_url
}

# Output the EKS cluster version
output "cluster_version" {
  description = "The Kubernetes version for the cluster."
  value       = module.eks.cluster_version
}

# Output the EKS cluster primary security group ID
output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster."
  value       = module.eks.cluster_primary_security_group_id
}

# Output the EKS cluster security group ID
output "cluster_security_group_id" {
  description = "ID of the cluster security group."
  value       = module.eks.cluster_security_group_id
}

# Output the EKS managed node groups
output "eks_managed_node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created."
  value       = module.eks.eks_managed_node_groups
}

# Output the EKS managed node groups autoscaling group names
output "eks_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by EKS managed node groups."
  value       = module.eks.eks_managed_node_groups_autoscaling_group_names
}


# Output the EKS managed node groups autoscaling group names
output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = module.eks.oidc_provider
}

# Add this new policy resource
resource "aws_iam_policy" "route53_policy" {
  name        = "${local.name}-route53-policy"
  description = "Policy for Route53 access from EKS nodes"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets"
        ]
        Resource = [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ]
        Resource = [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "s3_full_access_policy" {
  name        = "${local.name}-s3-full-access-policy"
  description = "Policy for full S3 access from EKS nodes"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:*"
        Resource = "*"
      }
    ]
  })
}
