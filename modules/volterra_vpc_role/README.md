# Volterra GCP VPC Role sub-module



<!-- spell-checker: disable -->
```hcl
module "vpc_role" {
  source    = "git::https://github.com/memes/volterra-lab//modules/volterra-vpc-role"
  target_id = "my-project-id"
  members   = ["serviceAccount:bigip@my-project-id.iam.gserviceaccount.com"]
}
```
<!-- spell-checker: enable -->

### Create the custom role for entire org, but do not explicitly assign membership

<!-- spell-checker: disable -->
```hcl
module "cfe_org_role" {
  source      = "memes/f5-bigip/google//modules/cfe-role"
  version     = "2.0.2"
  target_type = "org"
  target_id   = "my-org-id"
}
```
<!-- spell-checker: enable -->

### Create the custom role in the project with a fixed id, and assign to a BIG-IP service account

<!-- spell-checker: disable -->
```hcl
module "cfe_role" {
  source    = "memes/f5-bigip/google//modules/cfe-role"
  version   = "2.0.2"
  id = "my_custom_role"
  target_id = "my-project-id"
  members   = ["serviceAccount:bigip@my-project-id.iam.gserviceaccount.com"]
}
```
<!-- spell-checker: enable -->

<!-- spell-checker:ignore markdownlint bigip -->
<!-- markdownlint-disable MD033 MD034 -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | > 0.12 |
| google | >= 3.58 |

## Providers

| Name | Version |
|------|---------|
| random | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| role | terraform-google-modules/iam/google//modules/custom_role_iam | 6.4.1 |

## Resources

| Name |
|------|
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| target\_id | Sets the target for Volterra role creation; must be either an organization ID<br>(target\_type = 'org'), or project ID (target\_type = 'project'). | `string` | n/a | yes |
| id | An identifier to use for the new role; default is an empty string which will<br>generate a unique identifier. If a value is provided, it must be unique at the<br>organization or project level depending on value of target\_type respectively.<br>E.g. multiple projects can all have a 'bigip\_cfe' role defined,<br>but an organization level role must be uniquely named. | `string` | `""` | no |
| members | An optional list of accounts that will be assigned the custom role. Default is<br>an empty list. | `list(string)` | `[]` | no |
| target\_type | Determines if the Volterra role is to be created for the whole organization ('org')<br>or at a 'project' level. Default is 'project'. | `string` | `"project"` | no |
| title | The human-readable title to assign to the custom Volterra role. Default is<br>'Custom Volterra VPC role'. | `string` | `"Custom Volterra VPC role"` | no |

## Outputs

| Name | Description |
|------|-------------|
| qualified\_role\_id | The qualified role-id for the custom CFE role. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
