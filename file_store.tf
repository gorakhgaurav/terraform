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
    kms_key_name = var.keys  # <-- Enable KMS encryption

    export_options {
      access_mode   = "READ_WRITE"
      squash_mode   = "NO_ROOT_SQUASH"
      anon_uid      = 65534
      anon_gid      = 65534
    }
  }
}
