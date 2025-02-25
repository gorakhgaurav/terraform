# 🚀 Persistent Disk (Block Storage)
resource "google_compute_disk" "gke_block_storage" {
  name  = var.disk_name
  type  = var.disk_type
  size  = var.disk_size
  zone  = var.zone
  project = var.project_id
}
