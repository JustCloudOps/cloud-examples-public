variable "cluster_name" {
  description = "the name of the eks cluster"
  type        = string
}

variable "account_id" {
  description = "the account number"
  type        = string
}

variable "oidc_provider" {
  default = "oidc for eks cluster"
  type    = string
}

variable "alb_controller_namespace" {
  description = "the name of the alb controller service account"
  type        = string
  default     = "kube-system"
}

variable "alb_controller_sa_name" {
  description = "the name of the alb controller service account"
  type        = string
  default     = "aws-load-balancer-controller"
}