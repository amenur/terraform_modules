
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  # no rules defined, deny all traffic in this ACL

  tags = merge(
        var.project_tags,
        {
            Name = "${var.vpc_tags}-default-nacl"
        },
    )
}



resource "aws_network_acl" "public" {
    vpc_id = aws_vpc.this.id
    subnet_ids = aws_subnet.public.*.id

    tags = merge(
        var.project_tags,
        {
            Name = "${var.vpc_tags}-web-public-nacl"
        },
    )
}


resource "aws_network_acl_rule" "public_rules" {
    network_acl_id = aws_network_acl.public.id

    for_each = local.public_nacl
    rule_number = each.value.rule_number
    egress = each.value.egress
    protocol = each.value.protocol
    rule_action = each.value.rule_action
    cidr_block = each.value.cidr_block
    from_port = each.value.from_port
    to_port = each.value.to_port

  
}

resource "aws_network_acl" "private_app" {
#TODO -> Change when you need for your specific APP ports
    
    #count = var.count_private
    vpc_id = aws_vpc.this.id
    subnet_ids = [for i in range(6, 9, 1) : aws_subnet.private[i].id]

    tags = merge(
        var.project_tags,
        {
            Name = "${var.vpc_tags}-private-app-nacl"
        },
    )
}

resource "aws_network_acl_rule" "app_rules" {
    network_acl_id = aws_network_acl.private_app.id

    for_each = local.private_nacl.app
    rule_number = each.value.rule_number
    egress = each.value.egress
    protocol = each.value.protocol
    rule_action = each.value.rule_action
    cidr_block = each.value.cidr_block
    from_port = each.value.from_port
    to_port = each.value.to_port
  
}

resource "aws_network_acl" "private_db" {
#TODO -> Change when you need for your specific DB ports
    
    #count = var.count_private
    vpc_id = aws_vpc.this.id
    subnet_ids = [for i in range(3, 6, 1) : aws_subnet.private[i].id]

    tags = merge(
        var.project_tags,
        {
            Name = "${var.vpc_tags}-private-db-nacl"
        },
    )
}

resource "aws_network_acl_rule" "db_rules" {
    network_acl_id = aws_network_acl.private_db.id

    for_each = local.private_nacl.db
    rule_number = each.value.rule_number
    egress = each.value.egress
    protocol = each.value.protocol
    rule_action = each.value.rule_action
    cidr_block = each.value.cidr_block
    from_port = each.value.from_port
    to_port = each.value.to_port
  
}

resource "aws_network_acl" "private_reserved" {
#TODO -> Change when you need for your specific RESERVED ports
    
    #count = var.count_private
    vpc_id = aws_vpc.this.id
    subnet_ids = [for i in range(0, 3, 1) : aws_subnet.private[i].id]

    tags = merge(
        var.project_tags,
        {
            Name = "${var.vpc_tags}-private-reserved-nacl"
        },
    )
}

resource "aws_network_acl_rule" "reserved_rules" {
    network_acl_id = aws_network_acl.private_reserved.id

    for_each = local.private_nacl.reserved
    rule_number = each.value.rule_number
    egress = each.value.egress
    protocol = each.value.protocol
    rule_action = each.value.rule_action
    cidr_block = each.value.cidr_block
    from_port = each.value.from_port
    to_port = each.value.to_port
  
}