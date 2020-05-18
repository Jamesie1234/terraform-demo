#------networking/variables.tf

variable "vpc_cidr" {}

variable "public_cidrs" {
  type = "list"
  #default = [
    #"10.123.1.0/24",
    #"10.123.2.0/24"
  #]
}

variable "private_cidrs" {
  type = "list"
  #default = [
    #"10.123.3.0/24",
    #"10.123.4.0/24"
  #]
}

#variable "private_cidrs" {
  #type = "list"
#}

#variable "subnet_id" {}
#variable "route_table_id" {}

#variable "destination_cidr_block" {}

variable "accessip" {
  #default = "0.0.0.0/0"
}
