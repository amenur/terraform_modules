
resource "aws_default_security_group" "default_sg" {
    vpc_id = aws_vpc.this.id

    tags = merge(
        var.project_tags,
        {
            Name = "${var.vpc_tags}"
        }
    )
  
}

resource "aws_security_group" "public" {

    name = "web-public-sg"
    description = var.public_sg_description
    vpc_id = aws_vpc.this.id

    tags = merge(
        var.project_tags,
        {
            Name = "${var.vpc_tags}-web-public-sg"
        }
    )

    dynamic "ingress" {

        for_each = [for i in local.public_security_groups:
            {
            from_port = i.from_port
            to_port = i.to_port
            protocol = i.protocol
            description = i.description
            }
        ]

        content {
            from_port = ingress.value.from_port
            to_port = ingress.value.to_port
            protocol = ingress.value.protocol
            description = ingress.value.description
            cidr_blocks = ["0.0.0.0/0"]
        }

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

resource "aws_security_group" "bastion_host" {
    
    name = "Bastion-Host-sg"
    description = "Bastion-Host-sg"
    vpc_id = aws_vpc.this.id 

    tags = merge(
        var.project_tags,
        {
            Name = "${var.vpc_tags}-Bastion-Host-sg"
        }
    )

    dynamic "ingress" {

        for_each = [for i in local.private_security_group_bastion:
            {
            from_port = i.from_port
            to_port = i.to_port
            protocol = i.protocol
            description = i.description
            }
        ]

        content {
            from_port = ingress.value.from_port
            to_port = ingress.value.to_port
            protocol = ingress.value.protocol
            description = ingress.value.description
            cidr_blocks = ["0.0.0.0/0"]
        }

    }

}



resource "aws_security_group" "app" {

    name = "${local.tier_names[2]}-sg"
    description = "${local.tier_names[2]}-tier-sg"
    vpc_id = aws_vpc.this.id

    tags = merge(
        var.project_tags,
        {
            Name = "${var.vpc_tags}-${local.tier_names[2]}-sg"
        }
    )

    dynamic "ingress" {

        for_each = [for i in local.private_security_group_app:
            {
            from_port = i.from_port
            to_port = i.to_port
            protocol = i.protocol
            description = i.description
            security_groups = [aws_security_group.public.id]

            }
        ]

        content {
            from_port = ingress.value.from_port
            to_port = ingress.value.to_port
            protocol = ingress.value.protocol
            description = ingress.value.description
            security_groups = [aws_security_group.public.id]
        }

    }
  
  
}

resource "aws_security_group" "db" {

    name = "${local.tier_names[1]}-sg"
    description = "${local.tier_names[1]}-tier-sg"
    vpc_id = aws_vpc.this.id

    tags = merge(
        var.project_tags,
        {
            Name = "${var.vpc_tags}-${local.tier_names[1]}-sg"
        }
    )

    dynamic "ingress" {

        for_each = [for i in local.private_security_group_db:
            {
            from_port = i.from_port
            to_port = i.to_port
            protocol = i.protocol
            description = i.description
            security_groups = [aws_security_group.public.id]

            }
        ]

        content {
            from_port = ingress.value.from_port
            to_port = ingress.value.to_port
            protocol = ingress.value.protocol
            description = ingress.value.description
            security_groups = [aws_security_group.public.id]
        }

    }
  
}

resource "aws_security_group" "reserved" {
    
    name = "${local.tier_names[0]}-sg"
    description = "${local.tier_names[0]}-tier-sg"
    vpc_id = aws_vpc.this.id 

    tags = merge(
        var.project_tags,
        {
            Name = "${var.vpc_tags}-${local.tier_names[0]}-sg"
        }
    )

    dynamic "ingress" {

        for_each = [for i in local.private_security_group_reserved:
            {
            from_port = i.from_port
            to_port = i.to_port
            protocol = i.protocol
            description = i.description
            security_groups = [aws_security_group.public.id]

            }
        ]

        content {
            from_port = ingress.value.from_port
            to_port = ingress.value.to_port
            protocol = ingress.value.protocol
            description = ingress.value.description
            security_groups = [aws_security_group.public.id]
        }

    }

}

