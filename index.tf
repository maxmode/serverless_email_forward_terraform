variable "domain" {
  // Specify here on which domain you need redirects
  default = "yourdomain.com"
}
variable "route53_zone_id" {
  // Specify here AWS Route53 HostedZone ID, for domain yourdomain.com
  default = "Z1XXXXXXXXXX"
}
variable "aws_region" {
  // Change it if you prefer another region (but for email forwarding it's not critical)
  default = "eu-west-1"
}
variable "access_key" {
  // Access key of AWS user with admin access at least to: IAM, CloudFront, S3, Lambda, SES
  default = "ACCESS_KEY"
}
variable "secret_key" {
  //Secret key for your user
  default = "SECRET_KEY"
}
variable "recipients" {
  type = "list"
  default = [
    //Specify here incoming adresses, from which you need to redirect. All of them should be on yourdomain.com
    "address1@yourdomain.com",
    "address2@yourdomain.com",
    "address3@yourdomain.com",
    "admin@yourdomain.com",
    "info@yourdomain.com"
  ]
}

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
