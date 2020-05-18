#-----networking/outputs.tf
output "lab_vpc" {
 value = "${aws_vpc.tf_vpc.id}"
}

output "private_subnets" {
  value = "${aws_subnet.tf_private_subnet.*.id}"
}

output "public_subnets" {
  value = "${aws_subnet.tf_public_subnet.*.id}"
}

output "ec2_sg" {
  value = "${aws_security_group.tf_ec2_sg.id}"
}

output "public_sg" {
  value = "${aws_security_group.tf_public_sg.*.id}"
}

output "private_sg" {
  value = "${aws_security_group.tf_public_sg.*.id}"
}

output "private_subnet_ips" {
  value = "${aws_subnet.tf_private_subnet.*.cidr_block}"
}

output "public_subnet_ips" {
  value = "${aws_subnet.tf_public_subnet.*.cidr_block}"
}

output "nat_gateway" {
  value = ["aws_nat_gateway.tf_nat_gtw.*.id"]
}
