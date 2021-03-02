output "volterra_sa" {
  value       = local.volterra_sa
  description = <<EOD
The identity of the Volterra VPC service account.
EOD
}

output "volterra_site_id" {
  value       = volterra_gcp_vpc_site.quick_start.id
  description = <<EOD
The unique identifier for the provisioned Volterra GCP VPC site.
EOD
}

output "volterra_tf_output" {
  value       = volterra_tf_params_action.quick_start.tf_output
  description = <<EOD
The output from Volterra's site provisioner if 'apply' was the defined action. This
will be an empty string if 'plan' was the action (default).
EOD
}
