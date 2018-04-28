variable "domain" {}
variable "recipients" {
  type = "list"
}
variable "forward_to" {
  type = "list"
}
variable "route53_zone_id" {}
variable "aws_region" {}

data "aws_caller_identity" "current" {}
provider "archive" {
  version = "~> 1.0"
}
