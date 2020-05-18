#----root/outputs.tf-----

#----storage outputs------

output "Bucket Name" {
  value = "${module.storage.bucketname}"
}

#---Networking Outputs -----

#output "vpc_id" {
 # value = "${module.networking.lab_vpc}"
#}

output "public_subnets" {
  value = "${join(", ", module.networking.public_subnets)}"
}

output "private_subnets" {
  value = "${join(", ", module.networking.private_subnets)}"
}

output "Subnet IPs" {
  value = "${join(", ", module.networking.private_subnet_ips)}"
}

output "Public Security Group" {
  value = "${module.networking.public_sg}"
}

output "nat_gateway" {
  value = "${module.networking.nat_gateway}"
}

#---Compute Outputs ------

output "Public Instance IDs" {
  value = "${module.compute.server_id}"
}

output "Public Instance IPs" {
  value = "${module.compute.server_ip}"
}
