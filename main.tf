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

# Register a GCP Service Acount to use with Volterra in the designated project
module "gcp_sa" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "3.0.1"
  project_id = var.project_id
  prefix     = var.prefix
  names = [
    "volterra"
  ]
  generate_keys = true
}

locals {
  # Volterra GCP SA email is predictable; use this to avoid for_each/dyamic issues
  volterra_sa  = format("%s-volterra@%s.iam.gserviceaccount.com", var.prefix, var.project_id)
  short_region = replace(var.region, "/^[^-]+-([^0-9-]+)[0-9]$/", "$1")
  # For now, these values will match those in the AWS quickstart(s) which
  # assumes a VPC with CIDR 192.168.0.0/22
  inside_gw_cidr  = "192.168.0.128/25"
  outside_gw_cidr = "192.168.0.0/25"
  gke_node_cidr   = "192.168.1.0/24"
}

# Create a custom role for Volterra in project
module "gcp_role" {
  source      = "./modules/volterra_vpc_role/"
  target_type = "project"
  target_id   = var.project_id
  members = [
    format("serviceAccount:%s", local.volterra_sa)
  ]
  depends_on = [module.gcp_sa]
}

resource "volterra_cloud_credentials" "gcp_sa" {
  name = format("%s-gcp-volterra-sa", var.prefix)
  # TODO: @memes - Cloud Credentials must be created in system namespace
  namespace = "system"
  #namespace = var.volterra_namespace
  description = format("Volterra GCP credentials (%s)", var.prefix)
  labels      = var.labels
  gcp_cred_file {
    credential_file {
      clear_secret_info {
        url = format("string:///%s", base64encode(module.gcp_sa.key))
      }
    }
  }
  depends_on = [module.gcp_sa]
}

resource "volterra_network_policy_view" "quick_start" {
  name = format("%s-quick-start", var.prefix)
  # TODO: @memes -Quick-start network policy must be in system namespace
  namespace = "system"
  #namespace = var.volterra_namespace
  description = format("Network policy for GCP site (%s)", var.prefix)
  endpoint {
    prefix_list {
      prefixes = [
        local.gke_node_cidr
      ]
    }
  }

  ingress_rules {
    metadata {
      name        = format("%s-allow-service-ingress", var.prefix)
      description = format("Allow high-port ingress to GKE cluster (%s)", var.prefix)
    }
    rule_name = format("%s-allow-service-ingress", var.prefix)
    action    = "Allow"
    any       = true
    protocol_port_range {
      port_ranges = [
        "30000-32767",
      ]
      protocol = "TCP"
    }
  }
  egress_rules {
    metadata {
      name        = format("%s-deny-gdns-8-8-4-4-egress", var.prefix)
      description = format("Deny egress to Google DNS at 8.8.4.4 (%s)", var.prefix)
    }
    rule_name = format("%s-deny-gdns-8-8-4-4-egress", var.prefix)
    action    = "Deny"
    prefix_list {
      prefixes = [
        "8.8.4.4/32",
      ]
    }
    applications {
      applications = [
        "APPLICATION_DNS",
      ]
    }
  }
  egress_rules {
    metadata {
      name        = format("%s-allow-gdns-8-8-8-8-egress", var.prefix)
      description = format("Allow egress to Google DNS at 8.8.8.8 (%s)", var.prefix)
    }
    rule_name = format("%s-allow-gdns-8-8-8-8-egress", var.prefix)
    action    = "Deny"
    prefix_list {
      prefixes = [
        "8.8.8.8/32",
      ]
    }
    applications {
      applications = [
        "APPLICATION_DNS",
      ]
    }
  }
  egress_rules {
    metadata {
      name        = format("%s-allow-other-egress", var.prefix)
      description = format("Allow egress that is not specifically denied (%s)", var.prefix)
    }
    rule_name   = format("%s-allow-other-egress", var.prefix)
    action      = "Deny"
    any         = true
    all_traffic = true
  }
}

resource "volterra_forward_proxy_policy" "quick_start" {
  name = format("%s-quick-start", var.prefix)
  # TODO: @memes -Quick-start forward policy must be in system namespace
  # namespace = var.volterra_namespace
  namespace   = "system"
  description = format("Forward Proxy policy for GCP site (%s)", var.prefix)
  any_proxy   = true
  allow_list {
    metadata {
      name        = format("%s-allow-quick-start", var.prefix)
      description = format("List of allowed domain names for forward proxy policy (%s)", var.prefix)
    }
    default_action_next_policy = true
    default_action_deny        = false
    default_action_allow       = false
    dynamic "tls_list" {
      for_each = toset(var.volterra_forward_proxy_allowed_domains)
      content {
        exact_value = tls_list.value
      }
    }
  }
}

data "google_compute_zones" "zones" {
  project = var.project_id
  region  = var.region
  status  = "UP"
}

resource "random_shuffle" "zones" {
  input = data.google_compute_zones.zones.names
  keepers = {
    project = var.project_id
    region  = var.region
  }
}

resource "volterra_gcp_vpc_site" "quick_start" {
  name = format("%s-gcp-quick-start-site", var.prefix)
  # TODO: @memes - GCP VPC Site must be in system namespace
  # namespace = var.volterra_namespace
  namespace   = "system"
  description = format("GCP Quick Start VPC site (%s)", var.prefix)
  labels      = var.labels
  cloud_credentials {
    name      = volterra_cloud_credentials.gcp_sa.name
    namespace = volterra_cloud_credentials.gcp_sa.namespace
  }
  ssh_key                 = var.volterra_ssh_key
  gcp_region              = var.region
  instance_type           = var.volterra_instance_type
  logs_streaming_disabled = true
  ingress_egress_gw {
    gcp_certified_hw = "gcp-byol-multi-nic-voltmesh"
    gcp_zone_names   = random_shuffle.zones.result
    node_number      = 3
    inside_network {
      new_network {
        name = format("%s-inside", var.prefix)
      }
    }
    inside_subnet {
      new_subnet {
        subnet_name  = format("%s-inside-%s", var.prefix, local.short_region)
        primary_ipv4 = local.inside_gw_cidr
      }
    }
    outside_network {
      new_network {
        name = format("%s-outside", var.prefix)
      }
    }
    outside_subnet {
      new_subnet {
        subnet_name  = format("%s-outside-%s", var.prefix, local.short_region)
        primary_ipv4 = local.outside_gw_cidr
      }
    }
    active_network_policies {
      network_policies {
        name      = volterra_network_policy_view.quick_start.name
        namespace = volterra_network_policy_view.quick_start.namespace
      }
    }
    active_forward_proxy_policies {
      forward_proxy_policies {
        name      = volterra_forward_proxy_policy.quick_start.name
        namespace = volterra_forward_proxy_policy.quick_start.namespace
      }
    }
    no_global_network        = true
    no_inside_static_routes  = true
    no_outside_static_routes = true
  }
  # Destroy the VPC site before network policy view
  depends_on = [module.gcp_sa, volterra_network_policy_view.quick_start, volterra_forward_proxy_policy.quick_start]
}

resource "volterra_tf_params_action" "quick_start" {
  site_name       = volterra_gcp_vpc_site.quick_start.name
  site_kind       = "gcp_vpc_site"
  action          = var.volterra_site_provision_action
  wait_for_action = true
  depends_on      = [module.gcp_sa, module.gcp_role, volterra_gcp_vpc_site.quick_start]
}
