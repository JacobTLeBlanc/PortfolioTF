/**
 * Amplify used to host portfolio
 **/

data "local_file" "buildspec_local" {
  filename = "${path.module}/buildspec.yml"
}

data "aws_iam_policy_document" "assume_role_amplify_policy" {
  statement {
    sid = "lambdaAssumeRolePolicy"

    actions = ["sts:AssumeRole"]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "amplify_role" {
  name = "GetReposRole"

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
}