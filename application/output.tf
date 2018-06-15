output "jumpbox_fqdn" {
  value = "${azurerm_public_ip.jumpbox.fqdn}"
}

output "jumpbox_user" {
  value = "${azurerm_public_ip.jumpbox.user}"
}
