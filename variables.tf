variable resource_group_name {
  default = "nic-k8sdemo"
}

variable location {
  default = "Central US"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key" {
  default = "~/.ssh/server_rsa"
}

variable "dns_prefix" {
  default = "k8stest"
}

variable cluster_name {
  default = "k8stest"
}

variable "agent_count" {
  default = 3
}

variable "client_id" {}

variable "client_secret" {}
