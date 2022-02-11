variable "profile" {
  description = "AWS Profile used for the Infrastructure Provisioning"
  type        = string
  default     = "aramis"

}

variable "region" {
  description = "Region for Provisioning the Infrastructure"
  type        = string
  default     = "eu-west-1"
}


variable "vpc_id" {
  description = "Default VPC in the Region"
  type        = string
  default     = "vpc-073c2d12ccbf7574c"

}


variable "ssh_key_path" {
  description = "Path to public ssh key"
  type        = string
  default     = "/home/aramis/.ssh/id_rsa.pub"

}

variable "instance_type" {
  description = "Type of the provisioned EC2 Instance"
  type        = string
  default     = "t2.micro"

}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default = ""

}

variable "availability_zone" {
  description = "Availability Zone to provision the infrastructure"
  type        = string
  default     = "eu-west-1a"

}

variable "project_tags" {
  type = map(string)
  description = "Tags of the project"
  default = {
    Name = "Aramis-POC"
    Env = "dev"
    cost_center = "my_wallet"
  }
}


