resource "kubernetes_service" "gopher_search" {
  metadata {
    name = "gopher_search"
  }

  spec {
    selector {
      app = "${kubernetes_pod.example.metadata.0.labels.app}"
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
    name = "gopher_search"

    labels {
      app = "gopher_search"
    }
  }

  spec {
    container {
      image = "nicholasjackson/gopher_search:latest"
      name  = "gopher_search"

      env = [
        "DATABASE_URL=postgres://${var.azurerm_postgresql_server.test.name}@${var.db_user}:${var.db_pass}@${azurerm_postgresql_server.test.fqdn}:5432/gopher_search_production?sslmode=disable",
        "GO_ENV=production",
      ]
    }
  }
}
