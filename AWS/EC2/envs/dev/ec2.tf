module "ec2" {
  depends_on               = [module.vpc] # So the IGW gets created first
  source                   = "../../modules/ec2"
  frontend_sub_id          = module.vpc.frontend_sub_id
  backend_sub_id           = module.vpc.backend_sub_id
  frontend_security_grp_id = module.vpc.frontend_security_grp_id
  backend_security_grp_id  = module.vpc.backend_security_grp_id
  ec2_pub_key              = var.ec2_pub_key
  tags                     = local.tags
  rds_db_conn_map          = module.rds.rds_db_conn_map
  friendsapp_rds_pass      = var.friendsapp_rds_pass
}
