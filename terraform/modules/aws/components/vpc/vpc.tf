# VPC configuration is not the core focus of this example, so we'll leverage Anton Babenko's module
# We'll just expose the basic settings here

# I really hate that the module version can't be a variable, which prevents different envs being on different versions in this sort of configuration.
# If this module was in its own repo and we could refernece calling function by tag or github hash, we could have it like this and work around it. But I digress...

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "5.5.1"
  name                   = var.vpc_name
  cidr                   = var.vpc_cidr
  azs                    = var.vpc_azs
  private_subnets        = var.vpc_private_subnets
  public_subnets         = var.vpc_public_subnets
  enable_nat_gateway     = var.vpc_single_nat_gateway # only want single if any at all
  single_nat_gateway     = var.vpc_single_nat_gateway
  one_nat_gateway_per_az = var.vpc_one_nat_gateway_per_az
}