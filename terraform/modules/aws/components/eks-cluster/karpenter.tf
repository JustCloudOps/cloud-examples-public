module "karpenter" {
  count = var.deploy_karpenter_infra == true ? 1 : 0
  source = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "20.2.1"
  cluster_name = module.eks.cluster_name
  create_node_iam_role = false
  #Below the role arn defined in the first node group will also be used for karpenter
  node_iam_role_arn    =  module.eks.eks_managed_node_groups[keys(module.eks.eks_managed_node_groups)[0]].iam_role_arn
  create_access_entry = false
  }
