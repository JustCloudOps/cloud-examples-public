variable "cluster_name" {
  type = string
}

variable "sa_name" {
  description = "The name of the service account"
  type        = string
}

variable "sa_ns" {
  description = "The k8s namespace of the servicea ccount"
  type        = string
}

variable "sa_policy_doc" {
  description = "The iam policy doc for the sa role"
  type        = string
}

variable "create_k8s_ns" {
  description = "whether to create a kubernetes namespace"
  type        = bool
}
variable "create_k8s_sa" {
  description = "whether to create annotated kubernetes service account"
  type        = bool
}