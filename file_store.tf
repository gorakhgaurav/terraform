resource "google_filestore_instance" "filestore_instance" {
  name       = var.filestore_name
  project    = var.project_id
  zone       = var.zone
  tier       = var.tier

  networks {
    network = var.network
    modes   = ["MODE_IPV4"] 
  }

  file_shares {
    name         = var.share_name
    capacity_gb  = var.capacity_gb
  }
}
