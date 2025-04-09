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



resource "kubernetes_daemonset" "push_certs" {
  metadata {
    name      = "cert-pusher"
    namespace = "default"
    labels = {
      app = "cert-pusher"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "cert-pusher"
      }
    }

    template {
      metadata {
        labels = {
          app = "cert-pusher"
        }
      }

      spec {
        service_account_name = "cert"

        container {
          name  = "pusher"
          image = "google/cloud-sdk:slim"

          command = ["/bin/sh", "-c"]
          args = [
            <<-EOT
              CERT_PATH=/etc/ssl/certs/ca-certificates.crt
              SECRET_NAME=node-cert-$(hostname)
              if [ -f "$CERT_PATH" ]; then
                gcloud secrets create $SECRET_NAME --replication-policy="automatic" || true
                gcloud secrets versions add $SECRET_NAME --data-file=$CERT_PATH
              fi
              sleep 3600
            EOT
          ]

          volume_mount {
            name       = "certs"
            mount_path = "/etc/ssl/certs"
            read_only  = true
          }
        }

        volume {
          name = "certs"

          host_path {
            path = "/etc/ssl/certs"
            type = "Directory"
          }
        }
      }
    }
  }
}

