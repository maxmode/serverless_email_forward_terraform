resource "aws_route53_record" "ses_domain_verification" {
  zone_id = "${var.route53_zone_id}"
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "600"
  records = ["${aws_ses_domain_identity.email_domain.verification_token}"]
}

resource "aws_route53_record" "ses_mx" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.domain}"
  type = "MX"
  ttl = "1800"
  records = ["10 inbound-smtp.${var.aws_region}.amazonaws.com"]
}