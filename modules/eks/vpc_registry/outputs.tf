output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = module.vpc.name
}

output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = module.vpc.azs
}

output "private_subnets" {
  description = "List of Private Subnets IPs"
  value       = module.vpc.private_subnets
}

output "private_subnet_tags" {
  description = "List of VPC Private Subnets Tags"
  value = var.private_subnet_tags
}

output "public_subnets" {
  description = "List of Private Subnets IPs"
  value       = module.vpc.public_subnets
}

output "public_subnet_tags" {
  description = "List of VPC Public Subnets Tags"
  value = var.public_subnet_tags
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_tags" {
  description = "List of VPC Tags"
  value = var.vpc_tags
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}





