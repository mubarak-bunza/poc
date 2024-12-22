# Terraform GitHub Repository and Ruleset Management

This Terraform solution automates the management of GitHub repositories and branch protection rulesets. It creates or updates repositories and enforces branch protection policies to ensure compliance with organizational standards.

## Features

- Creates and manages GitHub repositories.
- Configures branch protection rules for `main` and `development` branches.
- Ensures pull requests are used for code changes, with restrictions on direct commits.
- Enforces approval workflows and prevents accidental branch deletion.

## Prerequisites

1. **Terraform**: Ensure Terraform is installed. You can download it from [here](https://www.terraform.io/downloads.html).
2. **GitHub Personal Access Token**: A token with appropriate permissions to manage repositories and rulesets.
3. **AWS S3 Bucket** (optional): For storing the Terraform state file.
4. **GitHub Organization/Owner**: Ensure you have admin rights to the repositories.

## Configuration

### Clone the Repository
```bash
# Clone the repository containing the Terraform code
$ git clone <repository_url>
$ cd <repository_directory>
```

### Setup Backend (Optional)
If using an S3 bucket for state storage, configure the `backend` block in your `provider.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "<your-s3-bucket-name>"
    key            = "terraform/statefile.tfstate"
    region         = "<your-region>"
  }
}
```

### Update Variables
Create a `terraform.tfvars` file with the following content, and replace the placeholders with your actual values:

```hcl
github_token     = "<your-github-token>"
organization     = "<your-github-organization>"
repository_names = ["repo-1", "repo-2"]
```

### Initialize Terraform
Run the following command to initialize Terraform and download required providers:

```bash
$ terraform init
```

### Import Existing Repositories
Use the `import_repos.sh` script to import existing repositories into the Terraform state:

```bash
#!/bin/bash

repositories=("repo-1" "repo-2")
module_path="module.github_rulesets.github_repository.repositories"

for repo in "${repositories[@]}"; do
  terraform import "${module_path}[\"${repo}\"]" "${repo}"
done
```

Make the script executable and run it:

```bash
$ chmod +x import_repos.sh
$ ./import_repos.sh
```

### Review the Execution Plan
Generate and review the execution plan to see what changes Terraform will make:

```bash
$ terraform plan
```

### Apply the Configuration
Apply the changes to create or update resources:

```bash
$ terraform apply
```

### Verify the Ruleset
After applying, verify that the branch protection ruleset has been enforced for the specified branches.

## Important Notes

1. **Prevent Destruction of Repositories**: The `prevent_destroy` lifecycle rule is enabled to avoid accidental repository deletion. To delete a repository, this rule must be removed manually.
2. **Sensitive Variables**: Avoid committing sensitive data, such as Personal Access Tokens, in version control. Use `.gitignore` to exclude `.tfvars` files.
3. **Branch Protection**: The solution enforces pull request workflows and prevents direct commits to `main` and `development` branches.

## File Structure

```plaintext
.
├── modules/
│   ├── github_rulesets/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── main.tf
├── variables.tf
├── terraform.tfvars
├── import_repos.sh
├── .gitignore
└── README.md
```

## Cleanup
To destroy all resources managed by Terraform:

```bash
$ terraform destroy
```

**Note**: Resources with `prevent_destroy` enabled will not be deleted.

