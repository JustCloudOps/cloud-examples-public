variable "cluster_name" {
    type = string
}

variable "sa_name" {
    description = "The name of the service account"
    type = string
}

variable "sa_ns" {
    description = "The k8s namespace of the servicea ccount"
    type = string
}

variable "sa_policy" {
    description = "The iam policy for the sa role"
    type = string
}

