variable "profile" {
    type = string
    description = "(optional) describe your variable"
}


# variable "region" {
#   type        = string
#   description = "Region for deploy the Infrastructure"
#   default     = "eu-west-1"
# }

# variable "project_name" {
#   type        = string
#   description = "Name of the project"
#   default = "Aws - Animals4Life"
# }

# variable "env" {
#   type        = string
#   description = "Environment of the deployment"
#   default = "dev"
# }

# variable "cost_center" {
#   type        = string
#   description = "(optional) describe your variable"
#   default = ""
# }


#########################################################
# VPC Configuration
#########################################################
variable "vpc_cidr_block" {
  type        = string
  description = "(required) VPC cidr block list"
  default     = "10.16.0.0/16"
}

variable "project_tags" {
  type = map(string)
  description = "(optional) describe your variable"
  default = {
    "Project_Name" = "aws-animals4life-poc"
    "Environment" = "dev"
    "Cost_center" = ""
  }
}

variable "vpc_tags" {
    description = "(optional) describe your variable"
    type = map(string)
    default = {
      Name = "animals4life-vpc"
    }
}

###########################################################
# Public Subnet Configurations
###########################################################
variable "public_cidr_block" {
  type        = list(any)
  description = "(required) List of public subnets ip's"
}


# variable "private_cidr_block" {
#     type = list(string)
#     description = "(required) List of private subnets ip's"
#     default = [ "10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20", "10.16.64.0/20", "10.16.80.0/20", "10.16.96.0/20", "10.16.128.0/20", "10.16.144.0/20", "10.16.160.0/20" ]
# }

variable "public_names" {
    type = list(string)
    description = "(optional) List of public subnets names"
    default = ["web-A", "web-B", "web-C"]
    }

# }
variable "count_public" {
  type = number
  description = "(optional) describe your variable"
}


#############################################################
# Private Subnets Configuration
#############################################################


# variable "private_subnets" {
#   type = object({
#     Name = list(string)
#     cidr = string
#     tiers = list(string)
#     newbits = string
#     tier_mask = string
#     max_private_subnets = string
#   })
#   description = "(optional) List of private subnets names"
#   default = {
#     Name = [ "reserved", "db", "app" ]
#     cidr = "10.16"
#     newbits = "64"
#     tiers = [ "reserved", "db", "app" ]
#     tier_mask = "/20"
#     max_private_subnets = "3"
#   }
# }

locals {
  sn = "sn"
  az_initial = ["A", "B", "C"]
  private_names = flatten([
     [for i in range(0, 3, 1) : "reserved-${local.az_initial[i]}"],  
     [for i in range(0, 3, 1) : "db-${local.az_initial[i]}"],
     [for i in range(0, 3, 1) : "app-${local.az_initial[i]}"],
  ])
}

variable "newbits" {
  type = number
  description = "(optional) describe your variable"
  default = 16
}

variable "prefix" {
  type = string
  description = "(optional) describe your variable"
  default = 16
}


locals {

    az_ids = data.aws_availability_zones.available.zone_ids
    az_names = data.aws_availability_zones.available.names
}

variable "private_cidr_block" {}

variable "count_private" {}



  # locals{
  #   tiers = {
  #     reserved_tier = [
  #       for subnet in var.private_subnets:
  #         "${var.private_subnets.cidr}.${var.private_subnets.newbits + (var.private_subnets.newbits * index(local.az_names, count.index))}.0/${var.private_subnets.tier_mask}"
  #         if index(local.az_names, az) < var.max_private_subnets
  #     ]
  #   }
  # }

#  locals {
#   cidr_1_private_subnets = 0
#   cidr_2_private_subnets = 64 "0" = { cidr = "10.16.0.0/20", availability_zone = local.az_names, ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, var.tier_subnet[each.key]), assign_ipv6_address_on_creation = "true"}
#   max_private_subnets    = 3

#  }

# locals {
#   az_subnets = {
#     az1_subnets = [
#       for az in local.az_names :
#         "${var.private_cidr_block}.${local.cidr_1_private_subnets + (local.newbits * index(local.az_names, az))}.0/20"
#           if index(local.az_names, az) < local.max_private_subnets
#     ]
#     az2_subnets = [
#       for az in local.az_names :
#         "${var.private_cidr_block}.${local.cidr_2_private_subnets + (local.newbits * index(local.az_names, az))}.0/20"
#           if index(local.az_names, az) < local.max_private_subnets
#     ]
#     az3_subnets = [
#       for az in local.az_names :
#         "${var.private_cidr_block}.${local.cidr_3_private_subnets + (local.newbits * index(local.az_names, az))}.0/20"
#           if index(local.az_names, az) < local.max_private_subnets
#     ]
#   }
# }
