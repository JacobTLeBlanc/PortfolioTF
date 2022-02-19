/**
 * Amplify used to host portfolio
 **/

data "local_file" "buildspec_local" {
  filename = "${path.module}/buildspec.yml"
}

data "aws_iam_policy_document" "assume_role_amplify_policy" {
  statement {
    sid = "AmplifyAssumeRolePolicy"

    actions = ["sts:AssumeRole"]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "portfolio_policy_document" {
  statement {
    sid = "PortfolioPolicy"

    effect = "Allow"

    actions = [
      "amplify:*",
      "secretsmanager:*",
      "kms:*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "portfolio_role_policy" {
  policy = data.aws_iam_policy_document.portfolio_policy_document.json
  role   = aws_iam_role.amplify_role.id
}

resource "aws_iam_role" "amplify_role" {
  name = "AmplifyRole"

  assume_role_policy = data.aws_iam_policy_document.assume_role_amplify_policy.json
}

resource "aws_amplify_app" "portfolio" {
  name = "portfolio"
  repository = "https://github.com/JacobTLeBlanc/Portfolio_2.0"

  build_spec = data.local_file.buildspec_local.content

  access_token = var.git_token
  iam_service_role_arn = aws_iam_role.amplify_role.arn
}

resource "aws_amplify_branch" "master" {
  app_id = aws_amplify_app.portfolio.id
  branch_name = "master"

  framework = "React"
  stage = "PRODUCTION"
}

//resource "aws_amplify_domain_association" "main_domain" {
//  app_id = aws_amplify_app.portfolio.id
//  domain_name = aws_route53_zone.primary.name
//
//  sub_domain {
//    branch_name = aws_amplify_branch.master.branch_name
//    prefix      = "www"
//  }
//}