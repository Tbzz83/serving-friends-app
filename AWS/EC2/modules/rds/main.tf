resource "aws_db_subnet_group" "rds_sub_group" {
  name       = "main"
  subnet_ids = [var.rds_sub_1_id, var.rds_sub_2_id]
  tags       = merge(var.tags, { "Name" = "${var.tags.project_name}-rds-sub-grp-${var.tags.env}" })
}

resource "aws_db_instance" "rds" {
  allocated_storage      = 5
  db_name                = var.tags.project_name
  engine                 = "mysql"
  db_subnet_group_name   = aws_db_subnet_group.rds_sub_group.name
  vpc_security_group_ids = [var.rds_secure_grp_id]
  instance_class         = "db.t3.micro"
  username               = "mysqladmin"
  password               = var.friendsapp_rds_pass
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  tags                   = merge(var.tags, { "Name" = "${var.tags.project_name}-rds-${var.tags.env}" })
}
