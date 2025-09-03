# ---------------------------------------------------------------------------------------------------------------------
# ¦ PROVIDER
# ---------------------------------------------------------------------------------------------------------------------
# NOTE: when executed from inside a Spacelift run, this provider is designed to require no setup at all
# https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs#running-inside-spacelift
provider "spacelift" {}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.8.0"

  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = ">= 1.0"
    }
  }
}
