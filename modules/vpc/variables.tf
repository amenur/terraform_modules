variable "profile" {
    type = string
    description = "(optional) describe your variable"
}

variable "cidr_block" {
  type        = string
  description = "(required) VPC cidr block list"
  default     = "10.16.0.0/16"
}

variable "public_cidr_block" {
  type        = map(string)
  description = "(required) List of public subnets ip's"
}


# variable "private_cidr_block" {
#     type = list(string)
#     description = "(required) List of private subnets ip's"
#     default = [ "10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20", "10.16.64.0/20", "10.16.80.0/20", "10.16.96.0/20", "10.16.128.0/20", "10.16.144.0/20", "10.16.160.0/20" ]
# }

# variable "subnet_names" {
#     type = map
#     description = "(required) List of subnets names"
#     default = {
#         0 = "reserved"
#         1 = "db"
#         2 = "app"
#         3 = "web"
#     }

# }

# variable "tags" {
#     description = "(optional) describe your variable"
#     type = object({

#     })
# }









# variable "region" {
#   type        = string
#   description = "Region for deploy the Infrastructure"
#   default     = "eu-west-1"
# }

# variable "profile" {
#   type        = string
#   description = "Profile used for infrastructure provisioning"
#   default     = "aramis"
# }

# variable "project_name" {
#   type        = string
#   description = "Name of the project"
# }

# variable "env" {
#   type        = string
#   description = "Environment of the deployment"
# }

# variable "cost_center" {
#   type        = string
#   description = "(optional) describe your variable"
# }

