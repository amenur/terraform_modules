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
    type = string
    default = "animals4life-vpc"
}

variable "module_enabled_vpc_flow_log" {
  type = bool
  description = "(optional) Enable/Disable VPC Flow Logs to CloudWatch (everything you need)"
  default = true
}

variable "kms_key_alias" {
  type = string
  description = "(optional) Alias for the KMS key used for encrypt vpc flow logs in CloudWatch"
  default = "alias/cloudwatch-vpc-flow-logs"
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

# Public Security Group

variable "public_sg_description" {
  type = string
  description = "(optional) describe your variable"
  default = "Default security group for public subnets"
}

variable "ingress_from_port" {
  type = list(number)
  description = "(optional) the number of the ingres port in the public security group"
  default = [80, 443]
}

variable "ingress_to_port" {
  type = list(number)
  description = "(optional) describe your variable"
  default = [80, 443]
}

variable "ingress_protocol" {
  type = string
  description = "(optional) describe your variable"
  default = "tcp"
}

variable "web_sg_ingress" {
  type = map(any)
  description = "(optional) describe your variable"
  default = {
    "from_port" = 80,
    "to_port" = 80,
    "protocol" = "tcp",
    "description" = "http to public subnets",
  }
  
}

variable "web_sg_egress" {
  type = map(any)
  description = "(optional) describe your variable"
  default = {
    "from_port" = 80
    "to_port" = 80
    "protocol" = "tcp"
    "description" = "http from public subnets"
  }
}

locals {
  public_security_groups = {
    http = {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      description = "http"
    }
    https = {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      description = "https"
    }
  }

  public_nacl = {
    http_ingress = {
      rule_number = 100
      egress = false
      protocol = "tcp"
      rule_action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 80
      to_port = 80
      
    }
    https_ingress = {
      rule_number = 101
      egress = false
      protocol = "tcp"
      rule_action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 443
      to_port = 443
      
    }
    ssh_ingress = {
      rule_number = 103
      egress = false
      protocol = "tcp"
      rule_action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 22
      to_port = 22
      
    }
    http_egress = {
      rule_number = 100
      egress = true
      protocol = "tcp"
      rule_action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 80
      to_port = 80
      
    }
    https_egress = {
      rule_number = 101
      egress = true
      protocol = "tcp"
      rule_action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 443
      to_port = 443
      
    }
    ssh_egress = {
      rule_number = 103
      egress = true
      protocol = "tcp"
      rule_action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 22
      to_port = 22
    }
    custom_tcp_egress = {
      rule_number = 199
      egress = true
      protocol = "tcp"
      rule_action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 1024
      to_port = 65535
    }
  }
}

locals {
  route_tables_tiers = [
    aws_route_table.private.*.id[0],
    aws_route_table.private.*.id[1],
    aws_route_table.private.*.id[2],
    aws_route_table.private.*.id[0],
    aws_route_table.private.*.id[1],
    aws_route_table.private.*.id[2],
    aws_route_table.private.*.id[0],
    aws_route_table.private.*.id[1],
    aws_route_table.private.*.id[2],
  ]
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
     #[for i in range(0, 3, 1) : "reserved-${local.az_initial[i]}"],
     [for i in range(0, 3, 1) : "${local.tier_names[0]}-${local.az_initial[i]}"],
     [for i in range(0, 3, 1) : "${local.tier_names[1]}-${local.az_initial[i]}"],
     [for i in range(0, 3, 1) : "${local.tier_names[2]}-${local.az_initial[i]}"],    
    #  [for i in range(0, 3, 1) : "db-${local.az_initial[i]}"],
    #  [for i in range(0, 3, 1) : "app-${local.az_initial[i]}"],
  ])
}


variable "module_enabled_ngw" {
  type = bool
  description = "(optional) Enable/Disable NAT Gateways and EIP for each AZ in the Public Subnets"
  default = true
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

    tier_names = ["reserved", "db", "app"]

    az_ids = data.aws_availability_zones.available.zone_ids
    az_names = data.aws_availability_zones.available.names
}

locals {
  private_security_group_bastion = {
      ingress = {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      description = "ssh"
    }
  }
  private_security_group_app = {
      ingress = {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      description = "ssh"
    }
  }
  private_security_group_db = {
    db = {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      description = "PostgreSQL Port"
    }
  }
  private_security_group_reserved = {
    reserved = {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      description = "ssh"
    }
  }

}

locals {
  ##TODO --> Rules ordered by tier : Web(tier 1: 1XX), App(tier 2: 2XX), Db(tier 3: 3XX), Reserved(tier 4: 4XX)
  private_nacl = {
      app = {
        # http_ingress = {
        #   rule_number = 100
        #   egress = false
        #   protocol = "tcp"
        #   rule_action = "allow"
        #   cidr_block = "0.0.0.0/0"
        #   from_port = 80
        #   to_port = 80
          
        # }
        # http_egress = {
        #   rule_number = 100
        #   egress = true
        #   protocol = "tcp"
        #   rule_action = "allow"
        #   cidr_block = "0.0.0.0/0"
        #   from_port = 80
        #   to_port = 80
          
        # }
        # https_ingress = {
        #   rule_number = 102
        #   egress = false
        #   protocol = "tcp"
        #   rule_action = "allow"
        #   cidr_block = "0.0.0.0/0"
        #   from_port = 443
        #   to_port = 443
          
        # }
        # https_egress = {
        #   rule_number = 102
        #   egress = true
        #   protocol = "tcp"
        #   rule_action = "allow"
        #   cidr_block = "0.0.0.0/0"
        #   from_port = 443
        #   to_port = 443
        #}
  
        ssh_ingress = {
          rule_number = 200
          egress = false
          protocol = "tcp"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 22
          to_port = 22
        }
        ssh_egress = {
          rule_number = 200
          egress = true
          protocol = "tcp"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 22
          to_port = 22
        }
        http_egress = {
          rule_number = 201
          egress = true
          protocol = "tcp"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 80
          to_port = 80
        }
        custom_tcp_egress = {
          rule_number = 299
          egress = true
          protocol = "tcp"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 1024
          to_port = 65535
        }
      }
      db = {
        postgresql_ingress = {
          rule_number = 300
          egress = false
          protocol = "tcp"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 5432
          to_port = 5432
          
        }
        http_egress = {
          rule_number = 301
          egress = true
          protocol = "tcp"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 80
          to_port = 80
        }
        custom_tcp_egress = {
          rule_number = 399
          egress = true
          protocol = "tcp"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 1024
          to_port = 65535
        }
      }
      reserved = {
        ssh_ingress = {
          rule_number = 400
          egress = false
          protocol = "tcp"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 22
          to_port = 22
          
        }
        ssh_egress = {
          rule_number = 400
          egress = true
          protocol = "tcp"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 22
          to_port = 22
          
        }
        http_egress = {
          rule_number = 401
          egress = true
          protocol = "tcp"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 80
          to_port = 80
        }
        custom_tcp_egress = {
          rule_number = 499
          egress = true
          protocol = "tcp"
          rule_action = "allow"
          cidr_block = "0.0.0.0/0"
          from_port = 1024
          to_port = 65535
        }
      }
    } 
} 



variable "private_cidr_block" {}

variable "count_private" {
  type = number
  description = "(optiona) Number of private subnets per tier"
  default = 3
}

variable "private_subnets_per_tier" {
  type = number
  description = "(optional) describe your variable"
  default = 3
}

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
