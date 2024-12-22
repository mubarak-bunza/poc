# List of repositories to manage
data "github_repository" "repos" {
  for_each = toset(var.repository_names)
  name     = each.value
}

module "github_rulesets" {
  source = "./modules/github_rulesets"

  repositories = { for repo in data.github_repository.repos : repo.name => repo.name }
  organization = var.organization
}