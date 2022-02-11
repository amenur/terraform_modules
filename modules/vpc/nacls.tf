
 resource "aws_default_network_acl" "default" {
   count = var.enable_nacls ? 1 : 0

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
     count = var.enable_nacls ? 1 : 0

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
      count = var.enable_nacls ? 1 : 0

      network_acl_id = aws_network_acl.public[0].id

      rule_number = local.public_nacl[count.index]["rule_number"]
      egress = local.public_nacl[count.index]["egress"]
      protocol = local.public_nacl[count.index]["protocol"]
      rule_action = local.public_nacl[count.index]["rule_action"]
      cidr_block = local.public_nacl[count.index]["cidr_block"]
      from_port = local.public_nacl[count.index]["from_port"]
      to_port = local.public_nacl[count.index]["to_port"]

  
 }

 resource "aws_network_acl" "private_app" {
 #TODO -> Change when you need for your specific APP ports

      count = var.enable_nacls ? 1 : 0
    

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
   count =  var.enable_nacls ? 1 : 0

   network_acl_id = aws_network_acl.private_app[0].id

     rule_number = local.private_nacl.app[count.index]["rule_number"]
     egress = local.private_nacl.app[count.index]["egress"]
     protocol = local.private_nacl.app[count.index]["protocol"]
     rule_action = local.private_nacl.app[count.index]["rule_action"]
     cidr_block = local.private_nacl.app[count.index]["cidr_block"]
     from_port = local.private_nacl.app[count.index]["from_port"]
     to_port = local.private_nacl.app[count.index]["to_port"]
  
 }

 resource "aws_network_acl" "private_db" {
 #TODO -> Change when you need for your specific DB ports

      count = var.enable_nacls ? 1 : 0

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
   count = var.enable_nacls ? 1 : 0

   network_acl_id = aws_network_acl.private_db[0].id


     rule_number = local.private_nacl.db[count.index]["rule_number"]
     egress = local.private_nacl.db[count.index]["egress"]
     protocol = local.private_nacl.db[count.index]["protocol"]
     rule_action = local.private_nacl.db[count.index]["rule_action"]
     cidr_block = local.private_nacl.db[count.index]["cidr_block"]
     from_port = local.private_nacl.db[count.index]["from_import"]
     to_port = local.private_nacl.db[count.index]["to_port"]

 }

 resource "aws_network_acl" "private_reserved" {
 #TODO -> Change when you need for your specific RESERVED ports

     count = var.enable_nacls ? 1 : 0

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
     count = var.enable_nacls ? 1 : 0

   network_acl_id = aws_network_acl.private_reserved[0].id

     rule_number = local.private_nacl.reserved[count.index]["rule_number"]
     egress = local.private_nacl.reserved[count.index]["egress"]
     protocol = local.private_nacl.reserved[count.index]["protocol"]
     rule_action = local.private_nacl.reserved[count.index]["rule_action"]
     cidr_block = local.private_nacl.reserved[count.index]["cidr_block"]
     from_port = local.private_nacl.reserved[count.index]["from_port"]
     to_port = local.private_nacl.reserved[count.index]["to_port"]

}