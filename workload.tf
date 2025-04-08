
resource "kubernetes_service_account" "ksa_cert" {
  metadata {
    name      = "cert"
    namespace = "default"
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.gke_cert.email
    }
  }
}

resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = google_service_account.gke_cert.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[default/cert]"
}
