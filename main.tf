provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "helm_release" "datadog_operator" {
  name       = "datadog-operator"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog-operator"
  namespace  = "default"
  create_namespace = true
}

resource "kubernetes_secret" "datadog_secret" {
  metadata {
    name      = "datadog-secret"
    namespace = "default"
  }

  data = {
    "api-key" = base64encode("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
  }
}

resource "kubernetes_manifest" "datadog_agent" {
  manifest = {
    "apiVersion" = "datadoghq.com/v2alpha1"
    "kind"       = "DatadogAgent"
    "metadata" = {
      "name"      = "datadog"
      "namespace" = "default"
    }
    "spec" = {
      "global" = {
        "site" = "datadoghq.eu"
        "credentials" = {
          "apiSecret" = {
            "secretName" = "datadog-secret"
            "keyName"    = "api-key"
          }
        }
      }
    }
  }
}

resource "kubernetes_manifest" "datadog_daemonset" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "DaemonSet"
    "metadata" = {
      "name"      = "datadog-agent"
      "namespace" = "default"
    }
    "spec" = {
      "template" = {
        "spec" = {
          "containers" = [{
            "name"  = "agent"
            "env" = [{
              "name"  = "DD_KUBELET_TLS_VERIFY"
              "value" = "false"
            }]
          }]
        }
      }
    }
  }
}

resource "kubernetes_pod" "test_pod" {
  metadata {
    name      = "test-pod"
    namespace = "default"
  }

  spec {
    container {
      image = "busybox"
      name  = "test"
      args  = ["sleep", "3600"]
    }
  }
}
