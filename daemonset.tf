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



resource "kubernetes_manifest" "secret_agent_daemonset" {
  manifest = yamldecode(<<-EOT
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: secret-cert
      namespace: default
    spec:
      selector:
        matchLabels:
          app: secret-cert
      template:
        metadata:
          labels:
            app: secret-cert
        spec:
          serviceAccountName: cert
          containers:
          - name: secret-cert
            image: google/cloud-sdk:slim
            command: ["/bin/sh", "-c"]
            args:
              - gcloud secrets versions access latest --secret=app-secret --format='get(payload.data)' | base64 -d > /secrets/secret.txt && sleep 3600
            volumeMounts:
              - name: secret-vol
                mountPath: /secrets
                readOnly: false
          volumes:
            - name: secret-vol
              emptyDir: {}
  EOT
  )
}
