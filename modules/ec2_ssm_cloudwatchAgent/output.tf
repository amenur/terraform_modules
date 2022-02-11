output "ip_instance" {
  value = aws_instance.web.public_ip
}

output "id_instance" {
    value = aws_instance.web.id
}

output "ssh" {
  value = "ssh -l ubuntu ${aws_instance.web.public_ip}"
}

