data "aws_availability_zones" "available" {
  state = "available"
  name = var.region
}

locals {
  subnet_prefix = "sn-"
}
resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = true

  # tags = var.tags

}

resource "aws_subnet" "public" {
  count                           = length(var.public_cidr_block)
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = cidrsubnet(var.public_cidr_block, var.newbits, data.aws_availability_zones.available.name_sufix)
  availability_zone_id            = data.aws_availability_zones.available[count.index]
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, count.index)
  assign_ipv6_address_on_creation = true


  #tags = var.tags

}
