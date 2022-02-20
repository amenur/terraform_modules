

locals {
  name_self_ami = "${var.project_name}-${var.self_ami_name}"
  name_new_ami = "${var.project_name}-${var.new_ami_name}"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  az = data.terraform_remote_state.vpc.outputs.availability_zones.names[0]
  subnet = data.terraform_remote_state.vpc.outputs.public_subnet
  public_sg = data.terraform_remote_state.vpc.outputs.public_security_group
  private_sg = data.terraform_remote_state.vpc.outputs.private_security_group

}

# -----------------------------------------------------------
# Control Resource Variables
# -----------------------------------------------------------

variable "enable_ssh_key_ssm_param_store" {
  type = bool
  description = "Enable/Disable SSM Parameter Store in SSH Keys"
  default = false
}

variable "enable_ssh_key_pem_local" {
  type = bool
  description = "Enable/Disable Local SSH Key Pair Store"
  default = true
}

variable "enable_public_sg" {
  type = bool
  description = "Enable/Disable Public Security Group for the instance"
  default = false
}

variable "enable_private_sg" {
  type = bool
  description = "Enable/Disable Public Security Group for the instance"
  default = true
}

variable "enable_new_ami" {
  type = bool
  description = "Enable/Disable New AMI Creation"
  default = false
}

variable "enable_self_ami" {
  type = bool
  description = "Enable/Disable Self AMI for an instance"
  default = true
}

variable "enable_new_instance" {
  type = bool
  description = "Enable/Disable Instance Creation"
  default = true
}

variable "enable_ebs_volume" {
  type = bool
  description = "Enable/Disable the creation of the EBS Volume for the EC2 Instance"
  default = true
}

# --------------------------------------------------------------
# KEY PAIR
# --------------------------------------------------------------

variable "private_key_algorithm" {
  type = string
  description = "Algorithm used for ssh key pair encryption"
  default = "RSA"
}

variable "rsa_bits" {
  type = number
  description = "Nuember of bits for the ssh key pair encryption algorithm"
  default = 4096
}

variable "ssh_key_path" {
  description = "Path to public ssh key"
  type        = string
  default     = "/home/aramis/.ssh/id_rsa.pub"
}

# -----------------------------------------------------------------
# IAM Resources
# -----------------------------------------------------------------

variable "amazon_ec2_role_for_ssm_policy_arn" {
  type = string
  description = "Policy ARN for Amazon EC2 Role For SSM"
  default = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

variable "cloudwatch_agent_server_policy_policy_arn" {
  type = string
  description = "Policy ARN for CloudWatch Agent"
  default = "arn:aws:iam::aws:policy/service-role/CloudWatchAgentServerPolicy"
}

variable "amazon_ssm_full_access" {
  type = string
  description = "Policy ARN for SSM Full Access"
  default = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

# -----------------------------------------------------------
# INIT Variables
# -----------------------------------------------------------
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
  default     = ""
}

variable "project_tags" {
  type = map(string)
  description = "Tags of the project"
  default = {
    Project_Name = "Aramis-Security-Instance-POC"
    Env = "dev"
    cost_center = "my_wallet"
  }
}

variable "most_recent" {
  type = bool
  description = "Enable/Disable the most recent search of an AMI"
  default = true
}

variable "owner" {
  type = string
  description = "Owner number of the AMI"
  default = "amazon"
}

variable "new_ami_name" {
  type = string
  description = "Name for search the new AMI"
  default = "amzn2-ami-hvm-2.*-x86_64-gp2"
}

variable "new_ami_virtualization_type" {
  type = string
  description = "Virtualization type of the new AMI"
  default = "hmv"
}

variable "new_ami_root_device_type" {
  type = string
  description = "Root device type of the new AMI"
  default = "ebs"
}

variable "self_ami_name" {
  type = string
  description = "Self AMI Name"
}

variable "self_ami_virtualization_type" {
  type = string
  description = "Self AMI Virtualization Type"
  default = "hvm"
}

variable "ebs_volume_size" {
  type = number
  description = "Disk Size for ebs volume"
  default = 1
}

variable "ebs_volume_type" {
  type = string
  description = "Ebs volume type"
  default = "gp3"
}

variable "ebs_volume_encrypted" {
  type = bool
  description = "Enable/Disable Ebs Volume Encrypted"
  default = true
}

variable "subnet_id" {
  type = string
  description = "ID of the subnet for placemente the instance"
  default = ""
}

variable "security_groups" {
  type = string
  description = "Security Group for the instance"
  default = ""
}

variable "enable_ec2_monitoring" {
  type = bool
  description = "Enable/Disable Monitoring"
  default = true
}

variable "enable_instance_termination_protection" {
  type = bool
  description = "Enable/Disable Instance Termination Protection. Disables the possibility of executing an instance termination through the api "
  default = true
}

