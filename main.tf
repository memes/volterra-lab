terraform {
  required_version = "~> 0.14"

  # NOTE: provider initialisation is handled in providers.tf
  required_providers {
    google = {
      version = "~> 3.58"
    }
    volterra = {
      source  = "volterraedge/volterra"
      version = "~> 0.1.1"
    }
  }
}

# Validate that access to Volterra API is succeeding
data "volterra_namespace" "ns" {
  name = var.volterra_namespace
}
