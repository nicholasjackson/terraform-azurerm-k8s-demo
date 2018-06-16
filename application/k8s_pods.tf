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
        value = "postgres://${var.db_user}@${azurerm_postgresql_server.gopher_search.name}:${random_string.sql_password.result}@${azurerm_postgresql_server.gopher_search.fqdn}:5432/gopher_search_production?sslmode=disable"
      }

      env {
        name  = "GO_ENV"
        value = "production"
      }
    }
  }
}

resource "kubernetes_replication_controller" "gopher_search" {
  metadata {
    name = "gopher-search"

    labels {
      app = "gopher-search"
    }
  }

  spec {
    selector {
      app = "gopher-search"
    }

    replicas = 3

    template {
      container {
        image = "nicholasjackson/gopher_search:latest"
        name  = "gopher_search"

        env {
          name  = "DATABASE_URL"
          value = "postgres://${var.db_user}@${azurerm_postgresql_server.gopher_search.name}:${random_string.sql_password.result}@${azurerm_postgresql_server.gopher_search.fqdn}:5432/gopher_search_production?sslmode=disable"
        }

        env {
          name  = "GO_ENV"
          value = "production"
        }

        resources {
          limits {
            cpu    = "0.5"
            memory = "512Mi"
          }

          requests {
            cpu    = "250m"
            memory = "50Mi"
          }
        }
      }
    }
  }
}
