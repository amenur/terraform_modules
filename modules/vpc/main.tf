data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  subnet_prefix = "sn"
  az_names = data.aws_availability_zones.available.names
  name_tag = {
    "Name" = "${local.subnet_prefix}-${var.subnet_names[each.key]}-${local.az_names[each.key]}"
  }
}
resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = true

  # tags = var.tags

}

resource "aws_subnet" "public" {
  for_each = var.public_cidr_block
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value
  availability_zone_id            = local.az_names[each.key]
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, each.key)
  assign_ipv6_address_on_creation = true


  tags = "${merge(
      local.name_tag, 
      var.project_tags,
    )
  }"
}
