
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs     = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.enable_single_nat_gateway

  reuse_nat_ips       = var.enable_reuse_ips
#  external_nat_ip_ids = "${aws_eip.nat.*.id}"
  enable_vpn_gateway  = var.enable_vpn_gateway

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classlink_dns_support

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = var.enable_flow_log
  create_flow_log_cloudwatch_log_group = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role  = var.create_flow_log_cloudwatch_iam_role
  flow_log_max_aggregation_interval    = var.flow_log_aggregation_interval

  tags = var.vpc_tags
  public_subnet_tags = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags

}
