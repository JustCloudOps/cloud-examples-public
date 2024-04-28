variable "env" {
  description = "the deployment environment"
  type        = string
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "cluster_name" {
  description = "the name of the eks cluster"
  type        = string
}
