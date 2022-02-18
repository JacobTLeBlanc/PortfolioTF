variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "git_token" {
  type        = string
  description = "GIT Token to authenticate API calls"
}