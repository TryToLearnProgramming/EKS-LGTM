resource "helm_release" "prometheus" {

  name             = "prometheus"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "kube-prometheus"
  version          = "8.22.3"
  timeout          = 300
  create_namespace = true
  namespace        = "monitoring"

  depends_on = [
    module.eks,
    module.vpc
  ]
}

# resource "helm_release" "grafana" {
#   name             = "grafana"
#   repository       = "https://charts.bitnami.com/bitnami"
#   chart            = "grafana"
#   version          = "9.8.4"
#   namespace        = "monitoring"
#   create_namespace = true
#   timeout          = 300


#   set {
#     name  = "persistence.enabled"
#     value = "true"
#   }

#   set {
#     name  = "persistence.storageClassName"
#     value = "gp3"
#   }

#   set {
#     name  = "persistence.size"
#     value = "10Gi"
#   }

#   set {
#     name  = "datasources.secretDefinition.apiVersion"
#     value = "1"
#   }

#   set {
#     name  = "datasources.secretDefinition.datasources[0].name"
#     value = "Prometheus"
#   }

#   set {
#     name  = "datasources.secretDefinition.datasources[0].type"
#     value = "prometheus"
#   }

#   set {
#     name  = "datasources.secretDefinition.datasources[0].url"
#     value = "http://prometheus-kube-prometheus-prometheus.monitoring.svc:9090"
#   }

#   set {
#     name  = "datasources.secretDefinition.datasources[0].access"
#     value = "proxy"
#   }

#   set {
#     name  = "datasources.secretDefinition.datasources[0].isDefault"
#     value = "true"
#   }

#   set {
#     name  = "global.storageClass"
#     value = "gp3"
#   }

#   depends_on = [
#     module.eks,
#     module.eks_blueprints_addons,
#     helm_release.prometheus,
#     module.vpc
#   ]
# }

# resource "kubernetes_cluster_role" "ingress_role" {
#   metadata {
#     name = "ingress-role"
#   }

#   rule {
#     api_groups = ["networking.k8s.io"]
#     resources  = ["ingresses"]
#     verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
#   }

#   depends_on = [
#     module.eks,
#     time_sleep.wait_for_kubernetes
#   ]
# }

# resource "kubernetes_cluster_role_binding" "ingress_role_binding" {
#   metadata {
#     name = "ingress-role-binding"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = kubernetes_cluster_role.ingress_role.metadata[0].name
#   }

#   subject {
#     kind      = "User"
#     name      = "system:serviceaccount:kube-system:terraform"
#     api_group = "rbac.authorization.k8s.io"
#   }
# }