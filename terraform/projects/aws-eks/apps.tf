#Components for applciation functionality go here.

#####
# Platform base apps
#####

module "external_secrets" {
  source = "../../modules/aws/apps/external-secrets"
  providers = {
    helm = helm.eks-cluster-1
  }
  depends_on = [module.eks-cluster-1]
}