########################################################################
# Update kubeconfig
########################################################################

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${local.name}"
  }
  depends_on = [module.eks]
}

########################################################################
# Create Monitoring Namespace
########################################################################

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      name        = "monitoring"
      environment = var.environment
      managed-by  = "terraform"
    }
  }

  depends_on = [null_resource.update_kubeconfig]
}

########################################################################
# Grafana Stack
########################################################################

resource "helm_release" "grafana-stack" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  create_namespace = true

  values = [templatefile("values/testings/grafana-values.yaml", {mock="mock"})]

  depends_on = [
    module.eks,
    module.eks_blueprints_addons,
  ]
}

#######################################################################
# Loki Stack
#######################################################################

# Create Secrets:
resource "kubernetes_secret" "canary_basic_auth" {
  metadata {
    name      = "canary-basic-auth"
    namespace = "monitoring"
  }

  data = {
    username = "loki"
    password = "password123"
  }
}

# deploy loki
resource "helm_release" "loki" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  namespace        = "monitoring"
  create_namespace = true

  values = [templatefile("values/testings/loki-values.yaml", {service_account_role_arn=aws_iam_role.loki_role.arn, loki_bucket_name=var.loki_bucket_name, loki_ruler_bucket_name=var.loki_ruler_bucket_name})]

  depends_on = [
    module.eks,
    module.eks_blueprints_addons,
    module.vpc,
    kubernetes_namespace.monitoring,
    kubernetes_secret.canary_basic_auth,
    helm_release.promtail
  ]
}

# ########################################################################
# # Loki S3 Buckets
# ########################################################################

resource "aws_s3_bucket" "loki_chunks" {
  bucket = var.loki_bucket_name

  tags = {
    Name        = var.loki_bucket_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket" "loki_ruler" {
  bucket = var.loki_ruler_bucket_name

  tags = {
    Name        = var.loki_ruler_bucket_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

########################################################################
# IAM Role for Loki
########################################################################

resource "aws_iam_role_policy" "loki_policy" {
  name = "${local.name}-loki-s3-policy"
  role = aws_iam_role.loki_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectTagging",
          "s3:PutObjectTagging"
        ]
        Resource = [
          aws_s3_bucket.loki_chunks.arn,
          "${aws_s3_bucket.loki_chunks.arn}/*",
          aws_s3_bucket.loki_ruler.arn,
          "${aws_s3_bucket.loki_ruler.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "loki_role" {
  name = "${local.name}-loki-service-account-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:aud" : "sts.amazonaws.com",
            "${module.eks.oidc_provider}:sub" : "system:serviceaccount:${kubernetes_namespace.monitoring.metadata[0].name}:loki"
          }
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Attach the policy using aws_iam_role_policy_attachment instead
# resource "aws_iam_role_policy_attachment" "loki_policy_attachment" {
#   role       = aws_iam_role.loki_role.name
#   policy_arn = aws_iam_role_policy.loki_policy.id
# }

########################################################################
# Promtail Stack
########################################################################

resource "helm_release" "promtail" {
  name             = "promtail"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "promtail"
  namespace        = "monitoring"
  create_namespace = true

  values = [templatefile("values/testings/promtail-values.yml", {mock="mock"})]
  
  
}