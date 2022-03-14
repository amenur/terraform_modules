
variable "region" {
  type = string
  description = "Region for deploy the infrastructure"
  default = "eu-west-1"
}

variable "profile" {
  type = string
  description = "Profile for deploy the infrastructure"
  default = "aramis"
}

variable "vpc_name" {
  type = string
  description = "Name of the VPC"
}

variable "vpc_cidr_block" {
  type = string
  description = "Cidr Block for the VPC"
}

variable "azs" {
  type = list(string)
  description = "List of Availabilities zones for deploy the VPC infrastructure"
}

variable "private_subnets" {
  type = list(string)
  description = "List of Private Subnets"
}

variable "public_subnets" {
  type = list(string)
  description = "List of Public Subnets"
}

variable "enable_nat_gateway" {
  type = bool
  description = "Enable/Disable the creation of the nat gateways"
}

variable "enable_single_nat_gateway" {
  type = bool
  description = "Enable/Disable the creation of one single nat gateway for all az's"
}

#variable "external_nat_ip_ids" {
#  type = string
#  description = "External NAT IPs IDs"
#}

#variable "enable_reuse_ips" {
#  type = bool
#  description = "Enable/Disable the reuse of ips"
#}

variable "enable_vpn_gateway" {
  type = bool
  description = "Enable/Disable the VPN Gateway in the VPN"
}

variable "enable_dns_hostnames" {
  type = bool
  description = "Enable/Disable dns hostnames"
  default = true
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable/Disable dns support"
  default     = true
}

#variable "enable_classiclink" {
#  type = bool
#  description = "Enable/Disable classiclink"
#  default = true
#}
#
#variable "enable_classlink_dns_support" {
#  type = bool
#  description = "Enable/Disable classiclink dns support"
#  default = true
#}

variable "enable_flow_log" {
  type = bool
  description = "Enable/Disable vpc flow log"
  default = false
}

variable "create_flow_log_cloudwatch_log_group" {
  type = bool
  description = "Create the flow log, cloudwatch log group"
  default = false
}

variable "create_flow_log_cloudwatch_iam_role" {
  type = bool
  description = "Create the iam role, necessary for the vpc flow log log group"
  default = false
}

variable "flow_log_aggregation_interval" {
  type = number
  description = "Vpc flow log aggregation interval"
  default = 60
}

variable "vpc_tags" {
  type = map(string)
  description = "Vpc tags"
}

variable "public_subnet_tags" {
  type = map(string)
  description = "Public subnet tags (for EKS, is necesary to stablish)"
}

variable "private_subnet_tags" {
  type = map(string)
  description = "Private subnet tags (for EKS, is necesary to stablish)"
}

#variable "enable_ssm_endpoint" {
#  type = bool
#  description = "Enable/Disable VPC Endpoint for SSM Service"
#  default = false
#}
#
#variable "ssm_endpoint_private_dns_enabled" {
#  type = bool
#  description = "Enable/Disable DNS for SSM Private Endpoint"
#  default = false
#}

