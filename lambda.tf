data "archive_file" "email_forward_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda/email_forward_${replace(var.domain, ".", "_")}_tf.zip"

  source {
    content  = "${replace(replace(file("${path.module}/lambda/index.js"),"example.com","${var.domain}"),"FORWARD_TO","${join(",", "${var.forward_to}")}")}"
    filename = "index.js"
  }
}

resource "aws_iam_role" "iam_email_forward_role" {
  name = "iam_email_forward_${replace(var.domain, ".", "_")}_tf"
  assume_role_policy = "${file("${path.module}/policy/lambda_role.json")}"
}

resource "aws_iam_policy" "iam_email_forward_policy" {
  name = "iam_email_forward_${replace(var.domain, ".", "_")}_tf"
  policy = "${replace(file("${path.module}/policy/lambda_email_s3_policy.json"),"S3-BUCKET-NAME","${aws_s3_bucket.s3_emails.bucket}")}"
}

resource "aws_iam_role_policy_attachment" "iam_email_forward_role-attach" {
  role       = "${aws_iam_role.iam_email_forward_role.name}"
  policy_arn = "${aws_iam_policy.iam_email_forward_policy.arn}"
}

resource "aws_lambda_function" "email_forward" {
  function_name    = "email_forward_${replace(var.domain, ".", "_")}_tf"
  role             = "${aws_iam_role.iam_email_forward_role.arn}"
  handler          = "index.handler"
  filename         = "${data.archive_file.email_forward_zip.output_path}"
  source_code_hash = "${data.archive_file.email_forward_zip.output_base64sha256}"
  runtime          = "nodejs6.10"
  timeout          = "10"
}

resource "aws_lambda_permission" "allow_ses" {
  statement_id   = "GiveSESPermissionToInvokeFunction"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.email_forward.function_name}"
  principal      = "ses.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}"
}
