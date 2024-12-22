resource "github_repository" "repositories" {
  for_each = var.repositories
  name     = each.value

  allow_squash_merge  = true
  allow_rebase_merge  = true
  allow_merge_commit  = true
  has_issues          = true
  has_projects        = true
  has_wiki            = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository_ruleset" "branch_protection" {
  for_each = var.repositories

  name        = "${each.value}_branch_protection"
  repository  = each.value
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main", "refs/heads/dev"]
      exclude = []
    }
  }

  rules {

    pull_request {
      dismiss_stale_reviews_on_push     = true
      required_approving_review_count   = 1
      required_review_thread_resolution = true
    }

    required_status_checks {
      required_check {
        context = "pull-request-review"
        integration_id = 0
      }
    }

    deletion         = true
    non_fast_forward = true
  }
}
