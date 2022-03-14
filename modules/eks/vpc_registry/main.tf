
data "aws_security_group" "default" {
  name = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs     = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.enable_single_nat_gateway

#  reuse_nat_ips       = var.enable_reuse_ips
  enable_vpn_gateway  = var.enable_vpn_gateway

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

#  enable_ssm_endpoint              = var.enable_ssm_endpoint
#  ssm_endpoint_private_dns_enabled = var.ssm_endpoint_private_dns_enabled
#  ssm_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = var.enable_flow_log
  create_flow_log_cloudwatch_log_group = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role  = var.create_flow_log_cloudwatch_iam_role
  flow_log_max_aggregation_interval    = var.flow_log_aggregation_interval

  tags = var.vpc_tags
  public_subnet_tags = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags

  default_route_table_tags   = { DefaultRouteTable = true }
}
