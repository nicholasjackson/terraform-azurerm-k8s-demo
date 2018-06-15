resource "kubernetes_service" "gopher_search" {
  metadata {
    name = "gopher-search"
  }

  spec {
    selector {
      app = "${kubernetes_pod.gopher_search.metadata.0.labels.app}"
    }

    session_affinity = "ClientIP"

    port {
      port        = 3000
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_pod" "gopher_search" {
  metadata {
    name = "gopher-search"

    labels {
      app = "gopher-search"
    }
  }

  spec {
    container {
      image = "nicholasjackson/gopher_search:latest"
      name  = "gopher_search"

      env {
        name  = "DATABASE_URL"
        value = "postgres://${azurerm_postgresql_server.test.name}@${var.db_user}:${var.db_pass}@${azurerm_postgresql_server.test.fqdn}:5432/gopher_search_production?sslmode=disable"
      }

      env {
        name  = "GO_ENV"
        value = "production"
      }
    }
  }
}
