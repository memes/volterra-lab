variable "tf_sa_email" {
  type        = string
  default     = ""
  description = <<EOD
The fully-qualified email address of the Terraform GCP service account to use
for GCP resource creation via account impersonation. If left blank (default)
then the invoker's account will be used.

E.g. if you have permissions to impersonate:

tf_sa_email = "terraform@PROJECT_ID.iam.gserviceaccount.com"
EOD
}

variable "tf_sa_token_lifetime_secs" {
  type        = number
  default     = 600
  description = <<EOD
The expiration duration for the Terraform GCP service account token, in seconds.
This value should be high enough to prevent token timeout issues during GCP
resource creation, but short enough that the token is useless replayed later.
Default value is 600 (10 mins).
EOD
}

variable "volterra_cert" {
  type        = string
  description = <<EOD
Path to the PEM certificate file to use for Volterra API authentication.
EOD
}

variable "volterra_key" {
  type        = string
  description = <<EOD
Path to the PEM private key file to use for Volterra API authentication.
EOD
}

variable "volterra_tenant" {
  type        = string
  description = <<EOD
The tenant ID to use with Volterra.
EOD
}

variable "volterra_namespace" {
  type        = string
  description = <<EOD
The Volterra namespace to use for resources.
EOD
}
