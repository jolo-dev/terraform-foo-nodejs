module "networking" {
  source = "./modules/networking"
}

module "instances" {
  source = "./modules/instances"

  region           = var.region
  public_subnets   = module.networking.public_subnets
  vpc_id           = module.networking.vpc_id
  desired_capacity = 2
}

module "database" {
  source = "./modules/database"

  region              = var.region
  private_subnets     = module.networking.private_subnets
  vpc_id              = module.networking.vpc_id
  private_cidr_blocks = module.networking.private_cidr_blocks
}
