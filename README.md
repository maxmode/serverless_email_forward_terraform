
## Introduction
This repository allows you to set-up a simple email forwarder without having a real mailbox.
You can have a nice email address on your domain name and all incoming emails will be redirected to your real address.

The functionality is based on AWS SES service. When incoming email is coming to SES, 
it writes email content to AWS S3 bucket and then executes AWS Lambda function. The Lambda
function reads email from S3 bucket and sends it to the list of recipients.
When recipient receives the email he can safely reply to it - email will be send to original sender.
However at this moment original sender will see that reply came from another address 
(your real mailbox).

Most of AWS configuration is done automatically via terraform,
which allows to manage your mailboxes in one place. 

In case there are modifications in mailbox lists - just run terraform again 
and it will apply all needed changes automatically.

## Preconditions
1. Verify all receiver emails in AWS SES manually
1. Create a rule set in AWS SES, if not exists, with name "default-rule-set", make it a default rule
1. Create a hosted zone in AWS Route 53 for your domain. The hosted zone should be in use for the domain.
1. Generate Access key and Access token for your AWS User
1. Install `terraform`

## Usage

### Include it as a module from github

```

provider "aws" {
  version = "~> 1.12"
  region = "eu-west-1"
  access_key = ?
  secret_key = ?
}

module "serverless_email_forward_terraform" {
  source       = "github.com/maxmode/serverless_email_forward_terraform"

  // Email domain.
  domain = ?
  
  // Route53 hosted zone, in which domain is registered.
  route53_zone_id = ?

  // Region for receiving emails.
  // Possible values: "eu-west-1", "us-east-1", "us-west-2".
  aws_region = "eu-west-1"

  // Email adresses on your domain
  recipients = [
    "hello@yourdomain",
    "admin@yourdomain",
    "info@yourdomain"
  ]
  
  // Where to forward emails ()
  forward_to = [
    "email1@example.com",
    "email2@example.com"
  ]
}


```

## Automated part
 
 - Run `terraform init`
 - Run `terraform apply`
 - Wait 10..20 min, until you receive a confirmation email from AWS that domain can be used AWS SES

### How to check?

Send an email to hello@yourdomain 
after few seconds it should end up at email1@example.com

## Cool part

Except using modern technologies like terraform and lambda this solution 
also saves your money, as AWS costs are mostly for 
Route53 hosted zone (around .5$ per month at the moment).
Storing emails in S3, executing AWS Lambda and SES should be even less.

Another great feature is automation of mailboxes registration and management. 
Especially helpful if you need to configure several emails on several domains.

## Credits

Based on the work of @arithmetric from: https://arithmetric/aws-lambda-ses-forwarder
