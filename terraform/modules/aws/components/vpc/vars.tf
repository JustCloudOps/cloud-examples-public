variable "vpc_name" {
  description = "the name of the vpc"
  type        = string
}

variable "vpc_cidr" {
  description = "cidr range of VPC"
  type        = string
}

variable "vpc_azs" {
  description = "a list of availability zones to use for the AZs"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "a list of the private ip ranges of the private subnets"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "a list of the private ip ranges of the public subnets"
  type        = list(string)
}

variable "vpc_single_nat_gateway" {
  description = "if a single nat gateway for all private subnets is used"
  type        = bool
}

variable "vpc_one_nat_gateway_per_az" {
  description = "if there is a single nat gateway per AZ"
  type        = bool
  default     = false
}
