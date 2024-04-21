
#####
# VPC
#####

module "vpc-1" {
  source                 = "../../../modules/aws/components/vpc"
  vpc_name               = "${local.env}-1"
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
  source          = "../../../modules/aws/components/eks-cluster"
  cluster_name    = "${local.env}-1"
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

#####
# Platform base apps
#####


module "metrics-server" {
  source = "../../../modules/k8s/metrics-server"
  providers = {
    helm = helm.eks-cluster-1
  }
  depends_on = [module.eks-cluster-1]
}


module "external_secrets" {
  source = "../../../modules/k8s/external-secrets"
  providers = {
    helm = helm.eks-cluster-1
  }
  #depends_on = [module.eks-cluster-1, module.alb_controller]
  depends_on = [module.eks-cluster-1]
}

/*
module "alb_controller" {
  source = "../../../modules/k8s/alb-controller"
  providers = {
    helm = helm.eks-cluster-1
  }
  account_id    = data.aws_caller_identity.current.account_id
  cluster_name  = module.eks-cluster-1.cluster.cluster_name
  oidc_provider = module.eks-cluster-1.cluster.cluster_oidc_issuer_url
  depends_on    = [module.eks-cluster-1]
}
*/

/* Uncomment to deploy ArgoCD with terrafrom 
module "argo_cd" {
  source = "../../../modules/k8s/argo-cd"
  providers = {
    helm = helm.eks-cluster-1
  }
  depends_on = [module.eks-cluster-1, module.external_secrets, module.alb_controller]
}
*/


#####
# apps
#####

module "test-external-secrets" {
  source = "../../../modules/aws/apps/test-external-secrets"
  cluster_name = module.eks-cluster-1.cluster.cluster_name
  providers = {
    kubernetes = kubernetes.eks-cluster-1
  }
  depends_on = [module.eks-cluster-1, module.external_secrets]
}

module "uploader-processor" {
    source = "../../../modules/aws/apps/uploader-processor"
    env = local.env
}