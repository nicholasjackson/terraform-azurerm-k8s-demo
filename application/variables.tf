variable "location" {}

variable "resource_group_name" {}

variable "subnets" {}

variable "db_user" {
  default = "postgres"
}

variable "jumpbox_user" {
  default = "azureuser"
}

variable "ssh_private_key" {}
variable "ssh_public_key" {}

variable "depend" {
  description = "Fake variable to bypass the need for depends_on at a module level"
}
