module "vpc" {
  source      = "../../modules/vpc"
  ec2_network = local.ec2_network
  tags        = local.tags
  my_ip_1     = var.my_ip_1
}
