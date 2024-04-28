
#####
# VPC
#####

module "vpc-1" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "5.5.1"
  name                   = "${local.env}-1"
  cidr                   = "10.0.0.0/16"
  azs                    = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets        = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  private_subnet_tags    = { "kubernetes.io/role/internal-elb" = "1" }
  public_subnets         = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
  public_subnet_tags     = { "kubernetes.io/role/elb" = "1" }
  enable_nat_gateway     = true # only want single if any at all
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}


#####
# EKS Cluster
#####


module "eks-cluster-1" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "20.2.1"
  cluster_name                             = "${local.env}-1"
  cluster_version                          = "1.28"
  cluster_endpoint_private_access          = true
  cluster_endpoint_public_access           = true
  cluster_endpoint_public_access_cidrs     = ["${chomp(data.http.myip.response_body)}/32"]
  enable_cluster_creator_admin_permissions = true
  cluster_addons = {
    coredns = {
      addon_version = "v1.10.1-eksbuild.2"
      kube-proxy = {
        addon_version = "v1.28.1-eksbuild.1"
      }
      vpc-cni = {
        addon_version = "v1.14.1-eksbuild.1"
      }
      aws-ebs-csi-driver = {
        addon_version = "v1.24.0-eksbuild.1"
      }
      aws-efs-csi-driver = {
        addon_version = "v1.7.0-eksbuild.1"
      }
    }
  }
  vpc_id     = module.vpc-1.vpc_id
  subnet_ids = module.vpc-1.private_subnets
  eks_managed_node_groups = {
    nodegroup1 = {
      min_size       = 2
      max_size       = 2
      desired_size   = 2
      instance_types = ["m5a.large"]
      capacity_type  = "ON_DEMAND"
    }
  }
}


module "karpenter_prereqs" {
  create               = contains(local.deploy_options.eks, "karpenter_prereqs")
  source               = "terraform-aws-modules/eks/aws//modules/karpenter"
  version              = "20.2.1"
  cluster_name         = module.eks-cluster-1.cluster_name
  create_node_iam_role = false
  #Below the role arn defined in the first node group will also be used for karpenter
  node_iam_role_arn   = module.eks-cluster-1.eks_managed_node_groups[keys(module.eks-cluster-1.eks_managed_node_groups)[0]].iam_role_arn
  create_access_entry = false
}


module "alb_controller" {
  count  = contains(local.deploy_options.eks, "alb_controller") == true ? 1 : 0
  source = "../../../modules/k8s/alb-controller"
  providers = {
    helm = helm.eks-cluster-1
  }
  account_id    = data.aws_caller_identity.current.account_id
  cluster_name  = module.eks-cluster-1.cluster_name
  oidc_provider = module.eks-cluster-1.cluster_oidc_issuer_url
  depends_on    = [module.eks-cluster-1]
}


#####
# apps
#####


module "uploader-processor" {
  source       = "../../../modules/aws/apps/uploader-processor"
  env          = local.env
  cluster_name = module.eks-cluster-1.cluster_name
  account_id   = data.aws_caller_identity.current.account_id
  providers = {
    kubernetes = kubernetes.eks-cluster-1
  }

  depends_on = [module.eks-cluster-1]
}