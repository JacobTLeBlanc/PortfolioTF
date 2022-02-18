/**
 * Amplify used to host portfolio
 **/

data "local_file" "buildspec_local" {
  filename = "${path.module}/buildspec.yml"
}

resource "aws_amplify_app" "portfolio" {
  name = "portfolio"
  repository = "https://github.com/JacobTLeBlanc/Portfolio_2.0"

  build_spec = data.local_file.buildspec_local.content

  access_token = var.git_token
}

resource "aws_amplif_branch" "master" {
  app_id = aws_amplify_app.portfolio.id
  branch_name = "master"

  framework = "React"
}