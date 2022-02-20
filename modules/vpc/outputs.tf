
#####################################
#########VPC OUTPUTS#################
#####################################

output "availability_zones" {
    value = try(data.aws_availability_zones.available, "")
}

output "vpc_id" {
    value = aws_vpc.this.id
}

output "vpc_arn" {
    value = aws_vpc.this.arn
}

output "vpc_tags" {
    value = aws_vpc.this.tags
}

output "vpc_cidr_block" {
    value = aws_vpc.this.cidr_block
}

output "default_security_group_id" {
    value = try(aws_vpc.this.default_security_group_id, "")
}

output "default_network_acl_id" {
    value = try(aws_vpc.this.default_network_acl_id, "")
}

output "default_route_table_id" {
    value = try(aws_vpc.this.default_route_table_id, "")
}

output "vpc_instance_tenancy" {
    value = try(aws_vpc.this.instance_tenancy, "")
}

output "vpc_main_route_table_id" {
    value = try(aws_vpc.this.main_route_table_id, "")
}

output "vpc_owner_id" {
    value = try(aws_vpc.this.owner_id, "")
}

output "public_internet_gateway_route_id" {
    value = aws_route.default_route.id
}

output "igw_id" {
    value = aws_internet_gateway.igw.*.id
}

output "igw_arn" {
    value = aws_internet_gateway.igw.*.arn
}

# VPC Flow Log
output "vpc_flow_log_id" {
    value = try(var.enable_vpc_flow_log ? aws_flow_log.vpc_flow_log[0].id : "")
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
    value = try(var.enable_vpc_flow_log ? aws_flow_log.vpc_flow_log[0].iam_role_arn : "")
}

output "vpc_flow_log_destination_arn" {
    value = try(var.enable_vpc_flow_log ? aws_flow_log.vpc_flow_log[0].log_destination : "")
}

output "kms_key_vpc_flow_log_arn" {
    value = try(var.enable_kms_key_vpc_flow_log ? aws_kms_key.cloudwatch_key[0].arn : "")
}

output "kms_key_vpc_flow_log_id" {
    value = try(var.enable_kms_key_vpc_flow_log ? aws_kms_key.cloudwatch_key[0].id : "")
}


#####################################
######### Public Subnets OUTPUTS ####
#####################################

output "public_subnets_id" {
    #value = values(aws_subnet.public)[*].id
    value = aws_subnet.public[*].id
}

output "public_subnets_arn" {
    value = aws_subnet.public[*].arn
}

output "public_subnets_cidr_block" {
    value = aws_subnet.public[*].cidr_block
}

output "public_subnets_tags" {
    value = aws_subnet.public[*].tags
}

output "public_route_table_ids" {
    value = aws_route_table.public_route_table[*].id
}

output "public_route_table_association_ids" {
    value = aws_route_table_association.public-association[*].id
}

output "nat_ids" {
    value = aws_eip.ngw_eip.*.id
}

output "nat_public_ips" {
    value = try(var.enable_ngw ? [for i in var.count_public : aws_eip.ngw_eip[*].public_ip] : "")
}

output "public_network_acl_id" {
    value = try(var.enable_nacls ? [for i in var.count_public : aws_network_acl.public[*].id] : "")
}

output "public_network_acl_arn" {
    value = try(var.enable_nacls ? [for i in var.count_public : aws_network_acl.public[*].arn] : "")
}

output "public_security_group" {
    value = aws_security_group.public.id
}



#####################################
######### Private Subnets OUTPUTS ###
#####################################

output "private_subnets_id" {
    #value = values(aws_subnet.public)[*].id
    value = aws_subnet.private[*].id
}

output "private_subnets_arn" {
    value = aws_subnet.private[*].arn
}

output "private_subnet_cidr_block" {
    value = aws_subnet.private[*].cidr_block
}

output "private_subnet_tags" {
    value = aws_subnet.private[*].tags
}

output "private_route_table_ids" {
    value = aws_route_table.private_route_table
}


output "private_nat_gateways_route_ids" {
    value = try(var.enable_ngw ? [for i in var.count_private : aws_route.private_to_ngw[*].id] : "")
}

output "private_route_table_association_id" {
    value = aws_route_table_association.private-association[*].id
}

output "nat_private_ips" {
    value = try(var.enable_ngw ? [for i in var.count_private : aws_eip.ngw_eip[*].private_ip] : "")
}
output "private_network_acl_id" {
    value = try(var.enable_nacls ? [for i in var.count_private : aws_network_acl.private_app[*].id] : "")
}

output "private_security_group_app" {
    value = aws_security_group.app.id
}

output "private_security_group_db" {
    value = aws_security_group.db.id
}

output "private_security_group_reserved" {
    value = aws_security_group.reserved.id
}




# ---------------------------------
#
# ---------------------------------
