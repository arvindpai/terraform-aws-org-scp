#
# Deny root account
#

data "aws_iam_policy_document" "deny_root_account" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    effect    = "Deny"
    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::*:root"]
    }
  }
}

resource "aws_organizations_policy" "deny_root_account" {
  name        = "deny-root-account"
  description = "Deny the root user from taking any action"
  content     = data.aws_iam_policy_document.deny_root_account.json
}

resource "aws_organizations_policy_attachment" "deny_root_account" {
  count = length(var.deny_root_account_target_ids)

  policy_id = aws_organizations_policy.deny_root_account.id
  target_id = element(var.deny_root_account_target_ids.*, count.index)
}


#
# Deny leaving AWS Organizations
#

data "aws_iam_policy_document" "deny_leaving_orgs" {
  statement {
    effect    = "Deny"
    actions   = ["organizations:LeaveOrganization"]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny_leaving_orgs" {
  name        = "deny-leaving-orgs"
  description = "Deny the ability for an AWS account or Organizational Unit from leaving the AWS Organization"
  content     = data.aws_iam_policy_document.deny_leaving_orgs.json
}

resource "aws_organizations_policy_attachment" "deny_leaving_orgs" {
  count = length(var.deny_leaving_orgs_target_ids)

  policy_id = aws_organizations_policy.deny_leaving_orgs.id
  target_id = element(var.deny_leaving_orgs_target_ids.*, count.index)
}

#
# Deny creating IAM users or access keys
#

data "aws_iam_policy_document" "deny_creating_iam_users" {
  statement {
    effect = "Deny"
    actions = [
      "iam:CreateUser",
      "iam:CreateAccessKey"
    ]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny_creating_iam_users" {
  name        = "deny-creating-iam-users"
  description = "Deny the ability to create IAM users or Access Keys"
  content     = data.aws_iam_policy_document.deny_creating_iam_users.json
}

resource "aws_organizations_policy_attachment" "deny_creating_iam_users" {
  count = length(var.deny_creating_iam_users_target_ids)

  policy_id = aws_organizations_policy.deny_creating_iam_users.id
  target_id = element(var.deny_creating_iam_users_target_ids.*, count.index)
}

#
# Deny deleting KMS Keys
#

data "aws_iam_policy_document" "deny_deleting_kms_keys" {
  statement {
    effect = "Deny"
    actions = [
      "kms:ScheduleKeyDeletion",
      "kms:Delete*"
    ]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny_deleting_kms_keys" {
  name        = "deny-deleting-kms-keys"
  description = "Deny deleting KMS keys"
  content     = data.aws_iam_policy_document.deny_deleting_kms_keys.json
}

resource "aws_organizations_policy_attachment" "deny_deleting_kms_keys" {
  count = length(var.deny_deleting_kms_keys_target_ids)

  policy_id = aws_organizations_policy.deny_deleting_kms_keys.id
  target_id = element(var.deny_deleting_kms_keys_target_ids.*, count.index)
}

#
# Deny deleting Route53 Hosted Zones
#

data "aws_iam_policy_document" "deny_deleting_route53_zones" {
  statement {
    effect = "Deny"
    actions = [
      "route53:DeleteHostedZone"
    ]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny_deleting_route53_zones" {
  name        = "deny-deleting-route53-zones"
  description = "Deny deleting Route53 Hosted Zones"
  content     = data.aws_iam_policy_document.deny_deleting_route53_zones.json
}

resource "aws_organizations_policy_attachment" "deny_deleting_route53_zones" {
  count = length(var.deny_deleting_route53_zones_target_ids)

  policy_id = aws_organizations_policy.deny_deleting_route53_zones.id
  target_id = element(var.deny_deleting_route53_zones_target_ids.*, count.index)
}

#
# Deny all access
#

data "aws_iam_policy_document" "deny_all_access" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "deny_all_access" {
  name        = "deny-all-access"
  description = "Deny all access AWS account or Organizational Unit"
  content     = data.aws_iam_policy_document.deny_all_access.json
}

resource "aws_organizations_policy_attachment" "deny_all_access" {
  count = length(var.deny_all_access_target_ids)

  policy_id = aws_organizations_policy.deny_all_access.id
  target_id = element(var.deny_all_access_target_ids.*, count.index)
}