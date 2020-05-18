#----networking/main.tf
#declaring data resource for AWS
data "aws_availability_zones" "available" {}

#create the vpc to host all the resources
resource "aws_vpc" "tf_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "tf_vpc"
  }
}

#craete internet gateway and attach it to the vpc
resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = "${aws_vpc.tf_vpc.id}"
  
  tags {
    Name = "tf_igw"
  }
}

#Create network acl
resource "aws_network_acl" "all" {
   vpc_id = "${aws_vpc.tf_vpc.id}"
    egress {
        protocol = "-1"
        rule_no = 2
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    tags {
        Name = "open acl"
    }
}

#create public route table within the vpc for the internet gateway
resource "aws_route_table" "tf_public_rt" {
  vpc_id = "${aws_vpc.tf_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tf_internet_gateway.id}"
  }

  tags {
    Name = "tf_public"
  }
}

#create private route table within the subnet
resource "aws_route_table" "tf_private_rt" {
  vpc_id = "${aws_vpc.tf_vpc.id}"

  route {
    cidr_block = "10.0.1.0/16"
  }

  tags {
    Name = "tf_public"
  }
}

#create multiple public subnets within the vpc using count and in two availability zones
resource "aws_subnet" "tf_public_subnet" {
  count                   = 2
  vpc_id                  = "${aws_vpc.tf_vpc.id}"
  cidr_block              = "${var.public_cidrs[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "tf_public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "tf_private_subnet" {
  count                   = 2
  vpc_id                  = "${aws_vpc.tf_vpc.id}"
  cidr_block              = "${var.private_cidrs[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  tags {
    Name = "tf_private_subnet_${count.index + 1}"
  }
}

#Associate public subnets to the public route table
resource "aws_route_table_association" "tf_public_assoc" {
  count          = "${aws_subnet.tf_public_subnet.count}"
  subnet_id      = "${aws_subnet.tf_public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.tf_public_rt.id}"
}

#Associate private subnets to the private route table
resource "aws_route_table_association" "tf_private_assoc" {
  count          = "${aws_subnet.tf_private_subnet.count}"
  subnet_id      = "${aws_subnet.tf_private_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.tf_private_rt.id}"
}

#create public security group within the vpc
resource "aws_security_group" "tf_public_sg" {
  name        = "tf_public_sg"
  description = "Used for access to the public instances"
  vpc_id      = "${aws_vpc.tf_vpc.id}"

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create ec2 security group within the vpc
resource "aws_security_group" "tf_ec2_sg" {
  name        = "tf_private_sg"
  description = "Used for access to the private instances"
  vpc_id      = "${aws_vpc.tf_vpc.id}"

#SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }

#HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Creat an aws_eip
resource "aws_eip" "one" {
  vpc                       = true
}

#Create NAT gateway
resource "aws_nat_gateway" "tf_nat_gtw" {
  allocation_id = "${aws_eip.one.id}"
  subnet_id = "${aws_subnet.tf_public_subnet.*.id}"
  depends_on = ["aws_internet_gateway.tf_internet_gateway"]
  

  tags {
    Name = "Nat gateway"
  }
}
