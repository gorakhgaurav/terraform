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
  name: cert-pusher
  namespace: default
spec:
  selector:
    matchLabels:
      app: cert-pusher
  template:
    metadata:
      labels:
        app: cert-pusher
    spec:
      serviceAccountName: cert
      containers:
      - name: gcloud-agent
        image: google/cloud-sdk:slim
        command: ["/bin/sh", "-c"]
        args:
          - |
            CERT_PATH="/certs/mycert.pem"
            SECRET_NAME="node-cert-$(hostname)"
            if [ -f $CERT_PATH ]; then
              gcloud secrets create $SECRET_NAME --data-file=$CERT_PATH --replication-policy=automatic || \
              gcloud secrets versions add $SECRET_NAME --data-file=$CERT_PATH
            else
              echo "Certificate not found at $CERT_PATH"
            fi
            sleep 3600
        volumeMounts:
        - name: cert-volume
          mountPath: /certs
          readOnly: true
      volumes:
      - name: cert-volume
        hostPath:
          path: /etc/my-certs  # <-- adjust this path as needed
          type: DirectoryOrCreate

  EOT
  )
}
