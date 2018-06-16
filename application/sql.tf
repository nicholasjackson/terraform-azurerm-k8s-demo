resource "random_string" "sql_password" {
  length           = 16
  special          = true
  override_special = "/@\" "
}

resource "azurerm_postgresql_server" "gopher_search" {
  name                = "postgresql-server-${var.resource_group_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  sku {
    name     = "B_Gen4_2"
    capacity = 2
    tier     = "Basic"
    family   = "Gen4"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "${var.db_user}"
  administrator_login_password = "${random_string.sql_password.result}"
  version                      = "9.5"
  ssl_enforcement              = "Disabled"
}

resource "azurerm_postgresql_database" "gopher_search" {
  name                = "gopher_search_production"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_postgresql_server.gopher_search.name}"
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "gopher_search" {
  name                = "all"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_postgresql_server.gopher_search.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.0.0"
}

resource "null_resource" "db" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    cluster_instance_ids = "${join(",", azurerm_postgresql_database.gopher_search.*.id)}"
  }

  depends_on = ["azurerm_virtual_machine.jumpbox"]

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host        = "${azurerm_public_ip.jumpbox.fqdn}"
    user        = "${var.jumpbox_user}"
    private_key = "${file("${var.ssh_private_key}")}"
  }

  provisioner "remote-exec" {
    # Bootstrap script to load initial SQL data to the database
    inline = [
      "wget https://github.com/nicholasjackson/gopher_search/releases/download/v0.1/configure_db.sh",
      "chmod +x ./configure_db.sh",
      "./configure_db.sh ${azurerm_postgresql_server.gopher_search.fqdn} ${var.db_user}@${azurerm_postgresql_server.gopher_search.name} ${random_string.sql_password.result}",
    ]
  }
}
