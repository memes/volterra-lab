<!-- spell-checker: ignore volterra markdownlint kubernetes -->
# Volterra Lab

Volterra, Terraform, GCP. Initially focused on automating the "Quick Start"
scenarios on GCP through Terraform automation, but will be expanded as needed.

## Quick starts

[ ] [Multi-Cloud Networking](https://www.volterra.io/docs/quick-start/multi-cloud-networking)
[ ] [Secure Kubernetes Gateway](https://www.volterra.io/docs/quick-start/secure-kubernetes-gateway)
[ ] [Web App Security & Performance](https://www.volterra.io/docs/quick-start/web-app-security-performance)
[ ] [App Delivery Network (ADN)](https://www.volterra.io/docs/quick-start/app-delivery-network)
[ ] [Edge Infrastructure & App Management](https://www.volterra.io/docs/quick-start/infrastructure-and-app-management)
[ ] [Edge Networking & Security](https://www.volterra.io/docs/quick-start/edge-networking-and-security)
[ ] [VoltShare Security & Sharing](https://www.volterra.io/docs/quick-start/volt-share)

## GCP and Volterra resources managed by Terraform

[x] Custom IAM role for Volterra
[x] Volterra service account in GCP project, with custom Volterra IAM role attached
[x] Service account credentials stored as Volterra Cloud Credentials
[x] GCP VPC Site Object
[ ] GKE cluster w/hipster-shop

<!-- markdownlint-disable MD033 MD034 -->
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
| google | ~> 3.58 |
| google.executor | ~> 3.58 |
| random | n/a |
| volterra | ~> 0.1.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| gcp_role | ./modules/volterra_vpc_role/ |  |
| gcp_sa | terraform-google-modules/service-accounts/google | 3.0.1 |

## Resources

| Name |
|------|
| [google_client_config](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) |
| [google_compute_zones](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) |
| [google_service_account_access_token](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/service_account_access_token) |
| [random_shuffle](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) |
| [volterra_cloud_credentials](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/cloud_credentials) |
| [volterra_forward_proxy_policy](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/forward_proxy_policy) |
| [volterra_gcp_vpc_site](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/gcp_vpc_site) |
| [volterra_network_policy_view](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/network_policy_view) |
| [volterra_tf_params_action](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/tf_params_action) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prefix | A unique prefix to apply to all resources; should be something short that<br>unequivocably identifies and groups resources. E.g. olympus username or email.<br><br>E.g.<br>prefix = "emes" | `string` | n/a | yes |
| project\_id | The GCP project identifier where the Volterra resources will be created. | `string` | n/a | yes |
| volterra\_cert | Path to the PEM certificate file to use for Volterra API authentication. | `string` | n/a | yes |
| volterra\_key | Path to the PEM private key file to use for Volterra API authentication. | `string` | n/a | yes |
| volterra\_namespace | The Volterra namespace to use for resources. | `string` | n/a | yes |
| volterra\_tenant | The tenant ID to use with Volterra. | `string` | n/a | yes |
| labels | An optional map of key:value labels to apply to resources created by Terraform.<br>Default is empty. Recommended that labels include the owner/username of the<br>resources. E.g.<br><br>labels = {<br>  owner = "memes"<br>} | `map(string)` | <pre>{<br>  "persistence": "delete-at-will"<br>}</pre> | no |
| region | The Google Compute region to use for deployed resources. Default is 'us-central1'. | `string` | `"us-central1"` | no |
| tf\_sa\_email | The fully-qualified email address of the Terraform GCP service account to use<br>for GCP resource creation via account impersonation. If left blank (default)<br>then the invoker's account will be used.<br><br>E.g. if you have permissions to impersonate:<br><br>tf\_sa\_email = "terraform@PROJECT\_ID.iam.gserviceaccount.com" | `string` | `""` | no |
| tf\_sa\_token\_lifetime\_secs | The expiration duration for the Terraform GCP service account token, in seconds.<br>This value should be high enough to prevent token timeout issues during GCP<br>resource creation, but short enough that the token is useless replayed later.<br>Default value is 600 (10 mins). | `number` | `600` | no |
| volterra\_forward\_proxy\_allowed\_domains | The list of domain names that will be allowed via Volterra Forward Proxy policy.<br>Each entry will be used as an exact match in the policy. Default set is<br>["github.com", "gcr.io", "storage.googleapis.com", "docker.io", "docker.com", "amazonaws.com"]. | `list(string)` | <pre>[<br>  "github.com",<br>  "gcr.io",<br>  "storage.googleapis.com",<br>  "docker.io",<br>  "docker.com",<br>  "amazonaws.com"<br>]</pre> | no |
| volterra\_instance\_type | The Google compute machine type to use for GCP VPC site nodes. Default is<br>'n1-standard-4'. | `string` | `"n1-standard-4"` | no |
| volterra\_site\_provision\_action | Terraform action to take on successful GCP VPC site registration; can be 'plan'<br>(default) or 'apply'. | `string` | `"plan"` | no |
| volterra\_ssh\_key | An optional SSH key to use for accessing the Volterra nodes. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| volterra\_sa | The identity of the Volterra VPC service account. |
| volterra\_site\_id | The unique identifier for the provisioned Volterra GCP VPC site. |
| volterra\_tf\_output | The output from Volterra's site provisioner if 'apply' was the defined action. This<br>will be an empty string if 'plan' was the action (default). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
