output "rds_db_conn_map" {
  value = {
    address = aws_db_instance.rds.address,
    db_name = aws_db_instance.rds.db_name
  }
}
