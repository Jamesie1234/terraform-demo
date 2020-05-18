#-----compute/main.tf

data "aws_ami" "server_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "tf_auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

data "template_file" "user-init" {
  count    = 2
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    firewall_private_subnets = "${element(var.private_subnet_ips, count.index)}"
  }

vars {
    firewall_public_subnets = "${element(var.public_subnet_ips, count.index)}"
  }
}

resource "aws_instance" "tf_server" {
  count         = "${var.instance_count}"
  instance_type = "${var.instance_type}"
  ami           = "${data.aws_ami.server_ami.id}"

  tags {
    Name = "tf_server-${count.index +1}"
  }

  key_name               = "${aws_key_pair.tf_auth.id}"
  vpc_security_group_ids = ["${var.private_security_group}"]
  subnet_id              = "${element(var.private_subnets, count.index)}"
  user_data              = "${data.template_file.user-init.*.rendered[count.index]}"
}

resource "aws_instance" "tf_bastion" {
  instance_type = "${var.instance_type}"
  ami           = "${data.aws_ami.server_ami.id}"

  tags {
    Name = "tf_bastion"
  }

  key_name               = "${aws_key_pair.tf_auth.id}"
  vpc_security_group_ids = ["${var.public_security_group}"]
  subnet_id              = "${element(var.public_subnets, count.index)}"
  user_data              = "${data.template_file.user-init.*.rendered[count.index]}"
}
