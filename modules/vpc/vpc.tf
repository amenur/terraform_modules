data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block                       = var.vpc_cidr_block
  enable_dns_hostnames             = true
  enable_dns_support               = true
  # assign_generated_ipv6_cidr_block = true

  tags = merge(
    var.project_tags,
  {
    Name = "${var.vpc_tags}"
  })
}

resource "aws_subnet" "public" {
  count = var.count_public

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.public_cidr_block[count.index]
  availability_zone               = local.az_names[count.index]
  #ipv6_cidr_block                 = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, count.index)
  # assign_ipv6_address_on_creation = true

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


# Create INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.project_tags,
  {
    Name = "${var.vpc_tags}-igw"
  })
}

# Create PUBLIC ROUTE TABLE 
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.project_tags,
  {
    Name = "${var.vpc_tags}-public-rt"
  })
  
}

resource "aws_route_table_association" "public-association" {
  count = var.count_public

  subnet_id = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public_route_table.id
  
}

# Create DEFAULT ROUTE IN PUBLIC SUBNETS TO IGW (public default route is where all traffic goes that isn't specifically destined for target endpoint inside the vpc)
resource "aws_route" "default_route" {
  route_table_id = aws_route_table.public_route_table.id 
  destination_cidr_block = "0.0.0.0/0"
  #destination_ipv6_cidr_block = "::/0"
  gateway_id = aws_internet_gateway.igw.id

}

# Create the DEFAULT ROUTE TABLE which is the default route table that is set as main (default) in the VPC
resource "aws_default_route_table" "main_route_table_private" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = merge(
    var.project_tags,
  {
    Name = "${var.vpc_tags}-default-rt"
  })
}

# Create ELASTIC IP for assign static ip address to the NAT GATEWAYS
resource "aws_eip" "ngw_eip" {
  count = var.enable_ngw ? var.count_public : 0
  

  vpc = true

  tags = merge(
    var.project_tags,
  {
    Name = "${var.vpc_tags}-eip-ngw"
  })
  
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_nat_gateway" "ngw" {
  count = var.enable_ngw ? var.count_public : 0

  allocation_id = aws_eip.ngw_eip.*.id[count.index]
  subnet_id = aws_subnet.public.*.id[count.index]

  tags = merge(
    var.project_tags,
  {
    Name = "${var.vpc_tags}-${local.az_names[count.index]}-ngw"
  })
  
}

resource "aws_route_table" "private_route_table" {
  count = var.count_public 

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.project_tags,
  {
    Name = "${var.vpc_tags}-private-${local.az_names[count.index]}-rt"
  })
  
}

resource "aws_route" "private_to_ngw" {
  count = var.enable_ngw ? var.count_public : 0

  route_table_id = aws_route_table.private_route_table.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.ngw.*.id[count.index]

}

resource "aws_route_table_association" "private-association" {
  count = var.count_private

  subnet_id = aws_subnet.private.*.id[count.index]
  route_table_id = element(local.route_tables_tiers, count.index)
  
}
