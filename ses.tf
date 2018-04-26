resource "aws_ses_domain_identity" "email_domain" {
  domain = "${var.domain}"
}

resource "aws_ses_domain_mail_from" "email_domain" {
  domain           = "${aws_ses_domain_identity.email_domain.domain}"
  mail_from_domain = "bounce.${aws_ses_domain_identity.email_domain.domain}"
}

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

resource "aws_route53_record" "spf" {
  zone_id = "${var.route53_zone_id}"
  name    = "${aws_ses_domain_mail_from.email_domain.mail_from_domain}"
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_ses_receipt_rule" "forward" {
  name          = "forward_${replace(var.domain, ".", "_")}_tf"
  rule_set_name = "default-rule-set"
  recipients    = "${var.recipients}"
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name = "${aws_s3_bucket.s3_emails.bucket}"
    object_key_prefix = "emails/"
    position = 1
  }

  lambda_action {
    function_arn = "${aws_lambda_function.email_forward.arn}"
    invocation_type = "Event"
    position = 2
  }
}
