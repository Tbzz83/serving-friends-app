output "backend_ec2_ip" {
  value = aws_instance.backend_ec2.public_ip
}

output "frontend_ec2_ip" {
  value = aws_instance.frontend_ec2.public_ip
}
