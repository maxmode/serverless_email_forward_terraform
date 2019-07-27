resource "aws_lambda_function" "email_forward" {
  function_name    = "email_forward_${replace(var.domain, ".", "_")}_tf"
  role             = "${aws_iam_role.iam_email_forward_role.arn}"
  handler          = "index.handler"
  filename         = "${data.archive_file.email_forward_zip.output_path}"
  source_code_hash = "${data.archive_file.email_forward_zip.output_base64sha256}"
  runtime          = "nodejs8.10"
  timeout          = "10"
}

resource "aws_lambda_permission" "allow_ses" {
  statement_id   = "GiveSESPermissionToInvokeFunction"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.email_forward.function_name}"
  principal      = "ses.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}"
}
