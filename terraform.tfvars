aws_region = "us-east-1"
aws_access_key = "AKIAROWYZ6YPJGFLTXJ3"
aws_secret_key = "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"
project_name = "tfdemo-terraform"
vpc_cidr = "10.123.0.0/16"
public_cidrs = [
    "10.123.1.0/24",
    "10.123.2.0/24"
    ]
private_cidrs = [
    "10.123.3.0/24",
    "10.123.4.0/24"
    ]
accessip = "0.0.0.0/0"
key_name = "tf_course_key"
public_key_path = "/home/robino/.ssh/id_rsa.pub"
server_instance_type = "t2.micro" 
instance_count = 2
