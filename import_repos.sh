#!/bin/bash

repositories=("django_blog" "devfoundry")
module_path="module.github_rulesets.github_repository.repositories"

for repo in "${repositories[@]}"; do
  terraform import "${module_path}" "${repo}"
done