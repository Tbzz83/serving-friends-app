output "frontend_sub_id" {
  value = aws_subnet.frontend_ec2_sub.id
}

output "backend_sub_id" {
  value = aws_subnet.backend_ec2_sub.id
}

output "rds_secure_grp_id" {
  value = aws_security_group.rds_secure_grp.id
}

output "rds_sub_1_id" {
  value = aws_subnet.rds_sub_1.id
}

output "rds_sub_2_id" {
  value = aws_subnet.rds_sub_2.id
}

output "frontend_security_grp_id" {
  value = aws_security_group.frontend_secure_grp.id
}

output "backend_security_grp_id" {
  value = aws_security_group.backend_secure_grp.id
}
