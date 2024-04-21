module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.2.1"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = var.endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      addon_version = var.coredns_addon_version
    }
    kube-proxy = {
      addon_version = var.kubeproxy_addon_version
    }
    vpc-cni = {
      addon_version = var.vpccni_addon_version
    }
    aws-ebs-csi-driver = {
      addon_version = var.ebs_addon_version
    }
    aws-efs-csi-driver = {
      addon_version = var.efs_addon_version
    }
  }


  vpc_id                  = var.vpc_id
  subnet_ids              = var.nodegroup_subnets
  eks_managed_node_groups = var.managed_nodegroups_config
}