// Email domain
domain = "yourdomain.test"
route53_zone_id = "Z1XXXXXXXXX"

// Forwarding rules
recipients = [
  "you@yourdomain.test",
  "admin@yourdomain.test",
  "info@yourdomain.test"
]
forward_to = [
  "your_gmail_email@gmail.com"
]

// Access to AWS account
aws_region = "eu-west-1"
access_key = "ACCESS_KEY"
secret_key = "SECRET_KEY"