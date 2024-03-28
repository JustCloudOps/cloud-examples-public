
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}