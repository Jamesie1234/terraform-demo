#provider 
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket = "terraform-latest-s3-20201215" #this s3 bucket need to be created in aws
    key    = "terraform/terraform.tfstate"  # this folder (terraform) needs to be create under the above bucket
    region = "us-east-1"
  }
}

# Deploy Storage Resource
module "storage" {
  source       = "./storage"
  project_name = "${var.project_name}"
}

# Deploy Networking Resources

module "networking" {
  source       = "./networking"
  vpc_cidr     = "${var.vpc_cidr}"
  public_cidrs = "${var.public_cidrs}"
  private_cidrs = "${var.private_cidrs}"
  accessip     = "${var.accessip}"
}

# Deploy Compute Resources

module "compute" {
  source          = "./compute"
  owners          = "${data.aws_ami.server_ami.id}"
  instance_count  = "${var.instance_count}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  instance_type   = "${var.server_instance_type}"
  public_subnets         = "${module.networking.public_subnets}"
  private_subnets = "${module.networking.private_subnets}"
  private_security_group  = "${module.networking.private_sg}"
  public_security_group  = "${module.networking.public_sg}"
  private_subnet_ips      = "${module.networking.private_subnet_ips}"
  public_subnet_ips = "${module.networking.public_subnet_ips}"
  #vpc = "${module.networking.lab_vpc}"
  #nat_gateway = "${module.networking.nat_gateway}"
}
