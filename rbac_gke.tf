resource "google_project_iam_binding" "gke_cluster_admin" {
  project = var.project_id
  role    = "roles/container.admin"  # Full control over GKE

  members = [
    "user:${var.gke_admin_user}",
    "serviceAccount:${var.gke_service_account}"
  ]
}

resource "google_container_cluster" "gke_cluster" {
  name     = "my-gke-cluster"
  location = var.region
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "gke_node_pool" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.gke_cluster.id
  node_count = 2

  node_config {
    service_account = var.gke_service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "kubernetes_role" "gke_developer_role" {
  metadata {
    name      = "gke-developer"
    namespace = "default"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "deployments"]
    verbs      = ["get", "list", "create", "update", "delete"]
  }
}

resource "kubernetes_role_binding" "gke_developer_role_binding" {
  metadata {
    name      = "gke-developer-binding"
    namespace = "default"
  }

  subject {
    kind      = "User"
    name      = var.gke_admin_user
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role.gke_developer_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}
