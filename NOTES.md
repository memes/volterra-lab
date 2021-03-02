# Notes
<!-- spell-checker: ignore Volterra -->

## Custom Role

* Additional roles are needed to successfully provision through Volterra TF apply

## GCP VPC Site

### Provisioning

* Volterra provisioning uses GCP project default service account
  * If service account is disabled, the site fails to onboard correctly

### De-provisioning

* Need to run `terraform destroy` twice to clean-up Network Policy view; first
  attempt will fail due to async nature of `volterra_gcp_vpc_site`
