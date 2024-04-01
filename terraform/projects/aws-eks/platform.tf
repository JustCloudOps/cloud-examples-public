#Components for the platform go here VPC, EKS clusters, observability infra, etc

#####
# VPC
#####

module "vpc-1" {
  source                 = "../../modules/aws/components/vpc"
  vpc_name               = "${local.project}-1"
  vpc_cidr               = "10.0.0.0/16"
  vpc_azs                = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_private_subnets    = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  vpc_public_subnets     = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
  vpc_single_nat_gateway = true # keep costs down for example
}

#####
# EKS Cluster
#####


module "eks-cluster-1" {
  source          = "../../modules/aws/components/eks-cluster"
  cluster_name    = "${local.project}-1"
  cluster_version = "1.28"
  vpc_id          = module.vpc-1.vpc_id

  endpoint_public_access               = true
  cluster_endpoint_public_access_cidrs = ["${chomp(data.http.myip.response_body)}/32"]

  coredns_addon_version   = "v1.10.1-eksbuild.2"
  kubeproxy_addon_version = "v1.28.1-eksbuild.1"
  vpccni_addon_version    = "v1.14.1-eksbuild.1"
  ebs_addon_version       = "v1.24.0-eksbuild.1"
  efs_addon_version       = "v1.7.0-eksbuild.1"

  nodegroup_subnets = module.vpc-1.private_subnets

  managed_nodegroups_config = {
    nodegroup1 = {
      min_size       = 2
      max_size       = 2
      desired_size   = 2
      instance_types = ["m5a.large"]
      capacity_type  = "ON_DEMAND"
    }
  }

  deploy_karpenter_infra = false
}
