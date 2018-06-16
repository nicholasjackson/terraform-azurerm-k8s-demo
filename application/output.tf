output "jumpbox_fqdn" {
  value = "${azurerm_public_ip.jumpbox.fqdn}"
}

output "jumpbox_user" {
  value = "${var.jumpbox_user}"
}

output "sql_password" {
  value = "${random_string.sql_password.result}"
}

output "app_URL" {
  value = "${kubernetes_service.gopher_search.load_balancer_ingress.0.ip}"
}
