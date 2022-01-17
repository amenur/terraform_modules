output "availability_zones" {
    value = data.aws_availability_zones.available
}

output "vpc_id" {
    value = aws_vpc.this.id
}

output "vpc_arn" {
    value = aws_vpc.this.arn
}

output "public_id" {
    #value = values(aws_subnet.public)[*].id
    value = aws_subnet.public[*].id
}

output "public_arn" {
    value = aws_subnet.public[*].arn
}

output "public_ips" {
    value = aws_subnet.public[*].cidr_block
}

output "public_subnet_tags" {
    value = aws_subnet.public[*].tags
}

output "vpc_tags" {
    value = aws_vpc.this.tags
}
