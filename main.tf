provider "azurerm" {}

provider "kubernetes" {
  host                   = "${module.kubernetes.host}"
  username               = "${module.kubernetes.username}"
  password               = "${module.kubernetes.password}"
  client_certificate     = "${base64decode(module.kubernetes.client_certificate)}"
  client_key             = "${base64decode(module.kubernetes.client_key)}"
  cluster_ca_certificate = "${base64decode(module.kubernetes.cluster_ca_certificate)}"
}

resource "azurerm_resource_group" "k8s" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

module "network" {
  source              = "Azure/network/azurerm"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
}

module "kubernetes" {
  source = "./kubernetes"

  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  ssh_public_key      = "${var.ssh_public_key}"
  subnets             = "${module.network.vnet_subnets[0]}"

  dns_prefix    = "${var.dns_prefix}"
  cluster_name  = "${var.cluster_name}"
  agent_count   = "${var.agent_count}"
  client_id     = "${var.client_id}"
  client_secret = "${var.client_secret}"
}

module "application" {
  source = "./application"

  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  subnets             = "${module.network.vnet_subnets[0]}"
  ssh_private_key     = "${var.ssh_private_key}"
}
