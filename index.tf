variable "domain" {}
variable "recipients" {
  type = "list"
}
variable "forward_to" {
  type = "list"
}
variable "route53_zone_id" {}

data "aws_caller_identity" "current" {}
provider "archive" {
  version = "~> 1.0"
}
