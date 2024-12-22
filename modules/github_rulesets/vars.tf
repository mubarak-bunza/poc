variable "organization" {
  description = "GitHub organization name"
  type        = string
}
variable "repositories" {
  description = "List of repository names to apply the rulesets."
  type        = map(string)
}
