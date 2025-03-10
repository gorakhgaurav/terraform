provider "google" {
  project = var.project_id
  region  = var.region
}

### Cluster Role: Reader ###
resource "kubernetes_cluster_role" "reader" {
  metadata {
    name = "clusterrole-reader"
  }

  rule {
    api_groups = [
      "config.istio.io",
      "security.istio.io",
      "networking.istio.io",
      "authentication.istio.io",
      "rbac.istio.io"
    ]
    resources = ["*"]
    verbs     = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources = [
      "endpoints", "pods", "services", "nodes", "replicationcontrollers",
      "namespaces", "secrets"
    ]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["networking.istio.io"]
    resources  = ["workloadentries"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources = [
      "csidrivers", "csinodes", "storageclasses",
      "volumeattachments", "volumeattachments/status"
    ]
    verbs = ["get", "list", "watch"]
  }
}

### Cluster Role: Admin ###
resource "kubernetes_cluster_role" "admin" {
  metadata {
    name = "clusterrole-admin"
  }

  rule {
    api_groups = [""]
    resources = [
      "pods", "pods/attach", "pods/exec", "pods/portforward", "pods/proxy",
      "deployments", "services", "configmaps", "namespaces"
    ]
    verbs = ["create", "delete", "deletecollection", "patch", "update", "get", "list", "watch"]
  }
}

### Bind ClusterRole "admin" to Group (Full Cluster Access) ###
resource "kubernetes_cluster_role_binding" "admin_binding" {
  metadata {
    name = "admin-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.admin.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "prc-axp-aa-e3-appadmin-gkepoc@aexp.com"  # Change this to the actual admin group
    api_group = "rbac.authorization.k8s.io"
  }
}

### Bind ClusterRole "reader" to User Group for Multiple Namespaces ###
resource "kubernetes_role" "namespace_reader" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "namespace-reader-role"
    namespace = each.key
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "deployments", "configmaps", "secrets"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "namespace_reader_binding" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "namespace-reader-binding"
    namespace = each.key
  }

  subject {
    kind      = "Group"
    name      = "prc-axp-gcp-e1-appuser-testapp@aexp.com"  # Change this to the actual user group
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role.namespace_reader[each.key].metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}
