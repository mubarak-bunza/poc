variable "repository_names" {
  description = "List of repository names to apply rulesets to"
  type        = list(string)
}

variable "organization" {
  description = "GitHub organization name"
  type        = string
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}
