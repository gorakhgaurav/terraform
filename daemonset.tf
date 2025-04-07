resource "kubernetes_daemonset" "fluentd" {
  metadata {
    name      = "fluentd"
    namespace = "default"
    labels = {
      app = "fluentd"
    }
  }

  spec {
    selector {
      match_labels = {
        name = "fluentd"
      }
    }

    template {
      metadata {
        labels = {
          name = "fluentd"
        }
      }

      spec {
        container {
          name  = "fluentd"
          image = "fluent/fluentd:v1.11-1"

          resources {
            limits = {
              cpu    = "100m"
              memory = "200Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "200Mi"
            }
          }

          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
          }
        }

        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
      }
    }
  }
}
