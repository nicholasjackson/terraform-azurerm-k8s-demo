variable "location" {}

variable "resource_group_name" {}

variable "subnets" {}

variable "db_user" {
  default = "postgres"
}

variable "db_pass" {
  default = "postgres$Changeme34sdlj"
}

variable "ssh_private_key" {}
