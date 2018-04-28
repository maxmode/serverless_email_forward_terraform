data "archive_file" "email_forward_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda/email_forward_${replace(var.domain, ".", "_")}_tf.zip"

  source {
    content  = "${replace(replace(file("${path.module}/lambda/index.js"),"example.com","${var.domain}"),"FORWARD_TO","${join(",", "${var.forward_to}")}")}"
    filename = "index.js"
  }
}