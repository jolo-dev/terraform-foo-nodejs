module "networking" {
  source = "./modules/networking"
}

module "database" {
  source = "./modules/database"

  region              = var.region
  private_subnets     = module.networking.private_subnets
  vpc_id              = module.networking.vpc_id
  public_cidr_blocks  = module.networking.public_cidr_blocks
}

module "instances" {
  source = "./modules/instances"

  region           = var.region
  public_subnets   = module.networking.public_subnets
  vpc_id           = module.networking.vpc_id
  database_ip      = module.database.database_ip
  key_pair_name    = module.database.key_pair_name
  desired_capacity = 2
}
