variable "prefix" {
  type = string

  description = <<EOD
A unique prefix to apply to all resources; should be something short that
unequivocably identifies and groups resources. E.g. olympus username or email.

E.g.
prefix = "emes"
EOD
}

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

variable "project_id" {
  type        = string
  description = <<EOD
The GCP project identifier where the Volterra resources will be created.
EOD
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = <<EOD
The Google Compute region to use for deployed resources. Default is 'us-central1'.
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

variable "labels" {
  type = map(string)
  default = {
    persistence = "delete-at-will"
  }
  description = <<EOD
An optional map of key:value labels to apply to resources created by Terraform.
Default is empty. Recommended that labels include the owner/username of the
resources. E.g.

labels = {
  owner = "memes"
}
EOD
}

variable "volterra_instance_type" {
  type        = string
  default     = "n1-standard-4"
  description = <<EOD
The Google compute machine type to use for GCP VPC site nodes. Default is
'n1-standard-4'.
EOD
}

variable "volterra_ssh_key" {
  type        = string
  default     = ""
  description = <<EOD
An optional SSH key to use for accessing the Volterra nodes.
EOD
}

variable "volterra_forward_proxy_allowed_domains" {
  type        = list(string)
  default     = ["github.com", "gcr.io", "storage.googleapis.com", "docker.io", "docker.com", "amazonaws.com"]
  description = <<EOD
The list of domain names that will be allowed via Volterra Forward Proxy policy.
Each entry will be used as an exact match in the policy. Default set is
["github.com", "gcr.io", "storage.googleapis.com", "docker.io", "docker.com", "amazonaws.com"].
EOD
}

variable "volterra_site_provision_action" {
  type        = string
  default     = "plan"
  description = <<EOD
Terraform action to take on successful GCP VPC site registration; can be 'plan'
(default) or 'apply'.
EOD
}
