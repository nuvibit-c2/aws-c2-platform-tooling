# ---------------------------------------------------------------------------------------------------------------------
# ¦ PROVIDER
# ---------------------------------------------------------------------------------------------------------------------
provider "github" {
  # github org which should be managed
  owner = "my-company"

  # it is recommended to use a GitHub App installation instead of a token to authenticate with github
  # https://registry.terraform.io/providers/integrations/github/latest/docs#github-app-installation
  app_auth {
    id              = var.app_id              # or `GITHUB_APP_ID` environment variable
    installation_id = var.app_installation_id # or `GITHUB_APP_INSTALLATION_ID` environment variable
    pem_file        = var.app_pem_file        # or `GITHUB_APP_PEM_FILE` environment variable
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.8.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.0"
    }
  }
}
