data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block                       = var.vpc_cidr_block
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = true

  tags = merge(
    var.vpc_tags,
    var.project_tags,
  )
}

resource "aws_subnet" "public" {
  count = var.count_public

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.public_cidr_block[count.index]
  availability_zone               = local.az_names[count.index]
  #ipv6_cidr_block                 = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, count.index)
  assign_ipv6_address_on_creation = true

  map_public_ip_on_launch = true


  tags = merge(
      var.project_tags,
    {
      "Name" = "${local.sn}-${var.public_names[count.index]}-public"
    },
  )
}


resource "aws_subnet" "private" {
  count = var.count_private
  #for_each = var.private_cidr_block

  vpc_id = aws_vpc.this.id
  cidr_block = element(var.private_cidr_block, count.index)
  availability_zone = element(local.az_names, count.index)
  
  tags = merge(
    var.project_tags,
    {
      "Name" = "${local.sn}-${local.private_names[count.index]}"
    },
  )
}







# resource "aws_subnet" "private" {
#   count = var.azs
#   vpc_id = aws_vpc.this.id
#   cidr_block = cidrsubnet(var.private_cidr_block)
#   availability_zone_id = local.az_ids[count.index]
  
# }

# resource "aws_subnet" "private" {
#   for_each = local.tiers.reserved_tier 

#   vpc_id                          = aws_vpc.this.id
#   cidr_block                      = local.reserved_tier[each.value.cidr]
#   availability_zone               = local.reserved_tier[each.value.availability_zone]
#   ipv6_cidr_block                 = local.reserved_tier[each.value.assig_ipv6_cidr_block]
#   assign_ipv6_address_on_creation = local.reserved_tier[each.value.assign_ipv6_address_on_creation]

#   tags = {
#     "Name" = local.reserved_tier[each.key]
#   }
# }
