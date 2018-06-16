output "kube_client_key" {
  value = "${module.kubernetes.client_key}"
}

output "kube_client_certificate" {
  value = "${module.kubernetes.client_certificate}"
}

output "kube_cluster_ca_certificate" {
  value = "${module.kubernetes.cluster_ca_certificate}"
}

output "kube_username" {
  value = "${module.kubernetes.username}"
}

output "kube_password" {
  value = "${module.kubernetes.password}"
}

output "kube_config" {
  value = "${module.kubernetes.kube_config}"
}

output "kube_host" {
  value = "${module.kubernetes.host}"
}

output "jumpbox_fqdn" {
  value = "${module.application.jumpbox_fqdn}"
}

output "jumpbox_user" {
  value = "${module.application.jumpbox_user}"
}

output "app_URL" {
  value = "${module.application.app_URL}"
}
