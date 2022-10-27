locals {
  Name = "aws-${var.region}-${var.stage}-${var.env}-${var.project}-rtype"
  common_tags = {
    env        = var.env
    project    = var.project
    team       = "Devops"
    owner      = "Hik"
    Managed_by = "Terraform"
  }
}