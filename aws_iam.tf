resource "aws_iam_role" "iam_email_forward_role" {
  name = "iam_email_forward_${replace(var.domain, ".", "_")}_tf"
  assume_role_policy = file("${path.module}/policy/lambda_role.json")
}

resource "aws_iam_policy" "iam_email_forward_policy" {
  name = "iam_email_forward_${replace(var.domain, ".", "_")}_tf"
  policy = replace(file("${path.module}/policy/lambda_email_s3_policy.json"),"S3-BUCKET-NAME","${aws_s3_bucket.s3_emails.bucket}")
}

resource "aws_iam_role_policy_attachment" "iam_email_forward_role-attach" {
  role       = aws_iam_role.iam_email_forward_role.name
  policy_arn = aws_iam_policy.iam_email_forward_policy.arn
}