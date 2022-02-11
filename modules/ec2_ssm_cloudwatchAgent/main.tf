
resource "aws_key_pair" "key_pair" {

  key_name   = "${var.project_name}-deployer-key"
  public_key = file(var.ssh_key_path)
}


data "aws_vpc" "my_vpc" {
  id = var.vpc_id
}


data "aws_ami" "new_ami" {
  count = var.new_ami_enable ? 1:0
  most_recent = var.most_recent
  owners = [var.owner]

  filter {
    name   = "name"
    values = [var.new_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.new_ami_virtualization_type]
  }

  #AMZN Linux 2
}



data "aws_ami" "self_ami" {
  count = var.self_ami_enable ? 1:0
  most_recent = var.most_recent
  owners = ["self"]

  filter {
    name   = "name"
#    values = ["amzn2-ami-hvm-2.*-x86_64-gp2"]
    values = [var.self_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.self_ami_virtualization_type]
  }

  #AMZN Linux 2
}



 resource "aws_subnet" "this" {
   vpc_id            = data.aws_vpc.selected.id
   availability_zone = var.az_name
   cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
 }



resource "aws_security_group" "this" {

  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.my_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }

}



resource "aws_instance" "this" {
  count = var.new_instance_enable ? 1:0

  ami           = data.aws_ami.amzn_linux_2.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name
  availability_zone = var.availability_zone
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id
  ]

  tags = var.project_tags

}



resource "aws_ebs_volume" "data" {

  availability_zone = var.availability_zone
  size              = 1
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "${var.project_name}-data"
  }

}



resource "aws_eip" "eip" {
  instance = aws_instance.web.id
  vpc      = true
  tags = {
    Name = "${var.project_name}-web-eip"
  }

}



resource "aws_volume_attachment" "attach_ebs_web" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.data.id
  instance_id = aws_instance.web.id
}
  