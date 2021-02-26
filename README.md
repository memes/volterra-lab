# Volterra Lab

Volterra, Terraform, GCP. More to come.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |
| google | ~> 3.58 |
| volterra | ~> 0.1.1 |

## Providers

| Name | Version |
|------|---------|
| google.executor | ~> 3.58 |
| volterra | ~> 0.1.1 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [google_client_config](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) |
| [google_service_account_access_token](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/service_account_access_token) |
| [volterra_namespace](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/data-sources/namespace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| volterra\_cert | Path to the PEM certificate file to use for Volterra API authentication. | `string` | n/a | yes |
| volterra\_key | Path to the PEM private key file to use for Volterra API authentication. | `string` | n/a | yes |
| volterra\_namespace | The Volterra namespace to use for resources. | `string` | n/a | yes |
| volterra\_tenant | The tenant ID to use with Volterra. | `string` | n/a | yes |
| tf\_sa\_email | The fully-qualified email address of the Terraform GCP service account to use<br>for GCP resource creation via account impersonation. If left blank (default)<br>then the invoker's account will be used.<br><br>E.g. if you have permissions to impersonate:<br><br>tf\_sa\_email = "terraform@PROJECT\_ID.iam.gserviceaccount.com" | `string` | `""` | no |
| tf\_sa\_token\_lifetime\_secs | The expiration duration for the Terraform GCP service account token, in seconds.<br>This value should be high enough to prevent token timeout issues during GCP<br>resource creation, but short enough that the token is useless replayed later.<br>Default value is 600 (10 mins). | `number` | `600` | no |

## Outputs

| Name | Description |
|------|-------------|
| ns\_id | n/a |
| ns\_tenant\_name | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
