########################################################################
# Ingress Nginx
########################################################################

# resource "helm_release" "ingress_nginx" {
#   name             = "ingress-nginx"
#   repository       = "https://kubernetes.github.io/ingress-nginx"
#   chart            = "ingress-nginx"
#   namespace        = "ingress-nginx"
#   create_namespace = true

#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
#     value = var.ssl_cert
#   }

#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
#     value = "http"
#   }

#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
#     value = "443"
#   }

#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
#     value = "nlb"
#   }

#   # Specify public subnets
#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-subnets"
#     value = join("\\,", module.vpc.public_subnets) # Use escaped comma separator
#   }

#   # Explicitly set to false to ensure it's not internal
#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal"
#     value = "false"
#   }

#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-negotiation-policy"
#     value = "ELBSecurityPolicy-TLS-1-2-2017-01"
#   }

#   # Configure service ports
#   set {
#     name  = "controller.service.ports.http"
#     value = "80"
#   }

#   set {
#     name  = "controller.service.ports.https"
#     value = "443"
#   }

#   set {
#     name  = "controller.service.targetPorts.http"
#     value = "http"
#   }

#   set {
#     name  = "controller.service.targetPorts.https"
#     value = "http" # Traffic is decrypted at the LB level
#   }

#   set {
#     name  = "controller.service.type"
#     value = "LoadBalancer"
#   }

#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-additional-resource-tags"
#     value = "Environment=prod"
#   }

#   lifecycle {
#     create_before_destroy = false
#   }

#   depends_on = [
#     module.eks,
#     module.eks_blueprints_addons,
#     module.vpc
#   ]
# }