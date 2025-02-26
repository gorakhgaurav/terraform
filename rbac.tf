resource "kubernetes_cluster_role_binding" "admin_access" {
  metadata {
    name = "gke-cluster-admin-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "User"
    name      = var.admin_user
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "read_access" {
  metadata {
    name = "gke-read-only-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"  # Read-only access
  }

  subject {
    kind      = "User"
    name      = var.read_only_user
    api_group = "rbac.authorization.k8s.io"
  }
}
