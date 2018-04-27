variable "domain" {}
variable "recipients" {
  type = "list"
}
variable "forward_to" {
  type = "list"
}
variable "route53_zone_id" {}
variable "aws_region" {}
variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  region = "${var.aws_region}"
  version = "~> 1.12"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}
data "aws_caller_identity" "current" {}

provider "archive" {
  version = "~> 1.0"
}
