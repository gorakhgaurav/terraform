# 🚀 Persistent Disk (Block Storage)
resource "google_compute_disk" "gke_block_storage" {
  name  = var.disk_name
  type  = var.disk_type
  size  = var.disk_size
  zone  = var.zone
  project = var.project_id
}
resource "kubernetes_storage_class" "gke_storage_class" {
  metadata {
    name = "gke-standard-rwo"
  }

  storage_provisioner = "pd.csi.storage.gke.io"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    type = var.disk_type  # pd-standard / pd-ssd
  }
}

resource "kubernetes_persistent_volume" "gke_pv" {
  metadata {
    name = "gke-pv"
  }

  spec {
    capacity = {
      storage = "${var.disk_size}Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"

    gce_persistent_disk {
      pd_name = google_compute_disk.gke_block_storage.name
      fs_type = "ext4"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "gke_pvc" {
  metadata {
    name      = "gke-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "${var.disk_size}Gi"
      }
    }
    storage_class_name = kubernetes_storage_class.gke_storage_class.metadata[0].name
  }
}
