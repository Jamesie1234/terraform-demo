#-----compute/variables.tf

variable "key_name" {}

variable "public_key_path" {}

variable "public_subnet_ips" {
  type = "list"
}

variable "private_subnet_ips" {
  type = "list"
}

variable "instance_count" {}

variable "instance_type" {}

variable "public_security_group" {}

variable "private_security_group" {}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}
