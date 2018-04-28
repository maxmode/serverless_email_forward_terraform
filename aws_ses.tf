resource "aws_ses_domain_identity" "email_domain" {
  domain = "${var.domain}"
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
