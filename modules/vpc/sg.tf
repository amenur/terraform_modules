
resource "aws_security_group" "public" {
    count = var.count_public
    
    name = "${var.public_names[count.index]}-public-sg"
    description = var.public_sg_description
    vpc_id = aws_vpc.this.id

    dynamic "ingress" {
        for_each = var.public_cidr_block
        content { 
            from_port = var.ingress_from_port
            to_port = var.ingress_to_port
            protocol = var.ingress_protocol
            cidr_blocks = ["${aws_subnet.public.*.cidr_block[count.index]}"]
        }
    }

    egress {
        from_port = local.egress.from_port
        to_port = local.egress.to_port
        protocol = local.egress.protocol
        cidr_blocks = local.egress.cidr_block
    }
  
}

resource "aws_security_group" "reserved" {
    
    name = "${local.tier_names[0]}-sg"
    description = "reserved-tier-sg"
    vpc_id = aws_vpc.this.id 

    dynamic "ingress" {
        for_each = [for i in range(0, 130, 64) : cidrsubnet("10.16.0.0/16", 8, i)]
        content {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            #cidr_blocks = [for i in range(0, 130, 64) : cidrsubnet("10.16.0.0/16", 8, i)]
            security_groups = [for i in range(0, var.count_public, 1): aws_security_group.public.*.id[i]]
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    depends_on = [
      aws_security_group.public
    ]

}

