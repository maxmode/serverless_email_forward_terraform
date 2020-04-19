resource "aws_s3_bucket" "s3_emails" {
  bucket = "emails-${replace(var.domain, ".", "-")}-tf"
  acl    = "private"
  policy = replace(replace(file("${path.module}/policy/s3_emails.json"),"S3-BUCKET-NAME","emails-${replace(var.domain, ".", "-")}-tf"),"AWS-ACCOUNT-ID", "${data.aws_caller_identity.current.account_id}")

  tags = {
    Name = "Emails for ${var.domain}"
  }
}
