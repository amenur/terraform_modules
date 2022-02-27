output "ip_instance" {
  value = aws_instance.this[*].public_ip
}

output "id_instance" {
  value = aws_instance.this[*].id
}

output "ssh" {
  value = "ssh -l ec2-user ${aws_instance.this[0].public_ip}"
}

