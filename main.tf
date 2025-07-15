module "vpc" {
  source = "./vpc"
}

module "database" {
  source         = "./database"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnets
  db_subnet_grp  = module.vpc.db_subnet_group
}

module "backend" {
  source         = "./backend"
  subnet_id      = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.vpc.backend_sg]
  key_name       = var.key_name
  instance_type  = var.instance_type
}

module "frontend" {
  source = "./frontend"
}

module "lambda" {
  source = "./lambda"
}

module "cloudwatch" {
  source = "./cloudwatch"
}
