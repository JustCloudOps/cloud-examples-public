#Components for applciation functionality go here.

#####
# Platform base apps
#####

module "metrics-server" {
  source = "../../modules/k8s/metrics-server"
  providers = {
    helm = helm.eks-cluster-1
  }
  depends_on = [module.eks-cluster-1]
}

/*
module "external_secrets" {
  source = "../../modules/k8s/external-secrets"
  providers = {
    helm = helm.eks-cluster-1
  }
  depends_on = [module.eks-cluster-1, module.alb_controller]
}

module "alb_controller" {
  source = "../../modules/k8s/alb-controller"
  providers = {
    helm = helm.eks-cluster-1
  }
  account_id    = data.aws_caller_identity.current.account_id
  cluster_name  = module.eks-cluster-1.cluster.cluster_name
  oidc_provider = module.eks-cluster-1.cluster.cluster_oidc_issuer_url
  depends_on    = [module.eks-cluster-1]
}

module "argo_cd" {
  source = "../../modules/k8s/argo-cd"
  providers = {
    helm = helm.eks-cluster-1
  }
  depends_on = [module.eks-cluster-1, module.external_secrets, module.alb_controller]
}
*/
