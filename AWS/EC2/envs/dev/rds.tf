module "rds" {
  source              = "../../modules/rds"
  tags                = local.tags
  friendsapp_rds_pass = var.friendsapp_rds_pass
  rds_sub_1_id        = module.vpc.rds_sub_1_id
  rds_sub_2_id        = module.vpc.rds_sub_2_id
  rds_secure_grp_id   = module.vpc.rds_secure_grp_id
}
