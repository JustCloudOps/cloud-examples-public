variable "cluster_name" {
  type        = string
  description = "the name of the eks cluster"
}

variable "cluster_version" {
  description = "The Kubernetes version to use for the control plane"
  type        = string
}

variable "endpoint_public_access" {
  description = "Whether the cluster should have a public endpoint. Making it true is probably a mistake"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "the vpc_id where cluster will be deployed"
  type        = string
}

variable "cluster_subnets" {
  description = "subnets for cluster object. Optionally, use the same subnets as the eks nodes"
  type        = list(string)
  default     = []
}

variable "endpoint_private_access" {
  description = "Whether the cluster should have a private endpoint"
  type        = bool
  default     = true
}

variable "create_eks_cluster_log_group" {
  description = "Whether or not to create a log group for the controlplane"
  type        = bool
  default     = true
}

variable "enabled_cluster_log_types" {
  description = "controlplane log types to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "how long to retain the logs in days"
  type        = number
  default     = 7
}

#eks-node-role.tf

variable "additional_node_role_policy_arns" {
  type        = list(string)
  description = "any additional policies"
  default     = []
}

#addons

variable "coredns_addon_version" {
  description = "the version coredns eks add-on"
  type        = string
  default     = ""
}

variable "kubeproxy_addon_version" {
  description = "the version kube-proxy eks add-on"
  type        = string
  default     = ""
}

variable "vpccni_addon_version" {
  description = "the version vpc-cni eks add-on"
  type        = string
  default     = ""
}

variable "ebs_addon_version" {
  description = "the version ebs eks add-on"
  default     = ""
}

variable "efs_addon_version" {
  description = "the version efs eks add-on"
  type        = string
  default     = ""
}

#nodegroup

variable "nodegroup_subnets" {
  description = "subnets for nodegroups"
  type        = list(string)
  default     = []
}


variable "managed_nodegroups_config" {
  description = "the configuration of the node group(s)"
  type = any
  default = {}
}

variable "nodegroup_maxunavailable" {
  description = "number of nodes allows to be unavailable"
  type        = number
  default     = 1
}

#karpenter

variable "deploy_karpenter_infra" {
  description = "whether to deploy the irsa role, cloudwatch event rules, sqs queues to support karpenter"
  type        = bool
  default     = false
}

#Argo CD