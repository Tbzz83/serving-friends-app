output "backend_ec2_ip" {
  value = module.ec2.backend_ec2_ip
}

output "frontend_ec2_ip" {
  value = module.ec2.frontend_ec2_ip
}

output "rds_db_conn_map" {
  value = module.rds.rds_db_conn_map
}
