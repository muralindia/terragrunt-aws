terraform {
  backend "s3" {}
}

resource "aws_organizations_account" "uat" {

  name = "prod"
  email = "chetanbn6@gmail.com"

  lifecycle {
    prevent_destroy = true
  }
}

output "aws_account_ids" {
  value = {
    uat = aws_organizations_account.prod.id
  }
}
