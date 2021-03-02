terraform {
  required_version = "> 0.12"
  required_providers {
    google = {
      version = ">= 3.58"
    }
  }
}

resource "random_id" "role_id" {
  byte_length = 4

  keepers = {
    target_type = var.target_type
    target_id   = var.target_id
  }
}

# Create a custom role for Volterra VPC
module "role" {
  source       = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version      = "6.4.1"
  target_level = var.target_type
  target_id    = var.target_id
  role_id      = coalesce(var.id, format("volterra_vpc_%s", random_id.role_id.hex))
  title        = var.title
  description  = <<EOD
Allow Volterra access to manage VPC resources.
EOD
  permissions = compact(concat(
    [
      "compute.backendServices.create",
      "compute.backendServices.delete",
      "compute.backendServices.get",
      "compute.backendServices.list",
      "compute.disks.create",
      "compute.disks.delete",
      "compute.disks.get",
      "compute.disks.list",
      "compute.disks.resize",
      "compute.firewalls.create",
      "compute.firewalls.delete",
      "compute.firewalls.get",
      "compute.firewalls.list",
      "compute.firewalls.update",
      "compute.forwardingRules.create",
      "compute.forwardingRules.delete",
      "compute.forwardingRules.get",
      "compute.forwardingRules.list",
      "compute.healthChecks.create",
      "compute.healthChecks.delete",
      "compute.healthChecks.get",
      "compute.healthChecks.list",
      "compute.images.create",
      "compute.images.get",
      "compute.images.list",
      "compute.images.useReadOnly",
      "compute.instanceGroupManagers.create",
      "compute.instanceGroupManagers.delete",
      "compute.instanceGroupManagers.get",
      "compute.instanceGroupManagers.list",
      "compute.instanceGroups.create",
      "compute.instanceGroups.delete",
      "compute.instanceGroups.get",
      "compute.instanceGroups.list",
      "compute.instanceTemplates.create",
      "compute.instanceTemplates.delete",
      "compute.instanceTemplates.get",
      "compute.instanceTemplates.list",
      "compute.instances.attachDisk",
      "compute.instances.create",
      "compute.instances.delete",
      "compute.instances.deleteAccessConfig",
      "compute.instances.detachDisk",
      "compute.instances.get",
      "compute.instances.list",
      "compute.instances.reset",
      "compute.instances.resume",
      "compute.instances.setLabels",
      "compute.instances.setMachineResources",
      "compute.instances.setMachineType",
      "compute.instances.setMetadata",
      "compute.instances.setServiceAccount",
      "compute.instances.setTags",
      "compute.instances.start",
      "compute.instances.stop",
      "compute.instances.update",
      "compute.instances.updateAccessConfig",
      "compute.instances.updateNetworkInterface",
      "compute.instances.use",
      "compute.machineTypes.list",
      "compute.networkEndpointGroups.attachNetworkEndpoints",
      "compute.networks.access",
      "compute.networks.create",
      "compute.networks.delete",
      "compute.networks.get",
      "compute.networks.list",
      "compute.networks.update",
      "compute.networks.updatePolicy",
      "compute.networks.use",
      "compute.networks.useExternalIp",
      "compute.routes.create",
      "compute.routes.delete",
      "compute.routes.get",
      "compute.routes.list",
      "compute.subnetworks.create",
      "compute.subnetworks.delete",
      "compute.subnetworks.get",
      "compute.subnetworks.list",
      "compute.subnetworks.setPrivateIpGoogleAccess",
      "compute.subnetworks.update",
      "compute.subnetworks.use",
      "compute.subnetworks.useExternalIp",
      "compute.zones.get",
      "iam.serviceAccounts.actAs",
      "iam.serviceAccounts.get",
      "iam.serviceAccounts.list",
      "resourcemanager.projects.get",
      # Emes added
      "compute.instanceTemplates.useReadOnly",
      "compute.regionBackendServices.create",
      "compute.regionBackendServices.delete",
      "compute.regionBackendServices.get",
      "compute.regionBackendServices.list",
      "compute.regionBackendServices.use",
      "compute.healthChecks.useReadOnly",
      "compute.instanceGroups.use",
      "compute.globalOperations.get",
      "compute.regionOperations.get",
    ],
    var.target_type == "org" ? ["resourcemanager.projects.list"] : [],
  ))
  members = var.members
}
