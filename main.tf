resource "google_compute_image" "f5xc_ce" {
  name    = local.f5xc_image_name
  project = var.gcp_project_id
  family  = var.machine_image_family

  guest_os_features {
    type = "MULTI_IP_SUBNET"
  }
  raw_disk {
    source = format("%s/%s.tar.gz", var.f5xc_ves_images_base_url, var.machine_image_base[var.f5xc_ce_gateway_type])
  }
}

module "vpc_slo" {
  source       = "terraform-google-modules/network/google"
  mtu          = 1460
  version      = "~> 6.0"
  project_id   = var.gcp_project_id
  network_name = "${var.project_prefix}-${var.project_name}-vpc-slo-${var.gcp_region}-${var.project_suffix}"
  subnets      = [
    {
      subnet_name   = "${var.project_prefix}-${var.project_name}-slo-${var.gcp_region}-${var.project_suffix}"
      subnet_ip     = "192.168.1.0/24"
      subnet_region = var.gcp_region
    }
  ]
}

module "vpc_sli" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 6.0"
  project_id   = var.gcp_project_id
  network_name = "${var.project_prefix}-${var.project_name}-vpc-sli-${var.gcp_region}-${var.project_suffix}"
  mtu          = 1460
  subnets      = [
    {
      subnet_name   = "${var.project_prefix}-${var.project_name}-sli-${var.gcp_region}-${var.project_suffix}"
      subnet_ip     = "192.168.2.0/24"
      subnet_region = var.gcp_region
    }
  ]
  delete_default_internet_gateway_routes = true
}

resource "google_compute_address" "nat" {
  count   = 1
  name    = "${module.vpc_slo.network_name}-${var.gcp_region}-nat-${count.index}"
  project = var.gcp_project_id
  region  = var.gcp_region
}

module "nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 2.0"
  project_id                         = var.gcp_project_id
  region                             = var.gcp_region
  router                             = "${var.project_prefix}-${var.project_name}-nat-router-${var.gcp_region}-${var.project_suffix}"
  create_router                      = true
  name                               = "${var.project_prefix}-${var.project_name}-nat-config-${var.gcp_region}-${var.project_suffix}"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  # nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat.*.self_link
  network                            = module.vpc_slo.network_name
}

module "gcp_secure_ce_multi_nic_existing_vpc" {
  source                   = "./modules/f5xc/ce/gcp"
  is_sensitive             = false
  gcp_region               = var.gcp_region
  project_name             = var.project_name
  machine_type             = var.machine_type
  ssh_username             = "centos"
  has_public_ip            = false
  # machine_image            = var.machine_image_base[var.f5xc_ce_gateway_type]
  machine_image            = google_compute_image.f5xc_ce.name
  instance_name            = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_public_key           = file(var.ssh_public_key_file)
  machine_disk_size        = var.machine_disk_size
  existing_network_outside = module.vpc_slo
  existing_network_inside  = module.vpc_sli
  f5xc_tenant              = var.f5xc_tenant
  f5xc_api_url             = var.f5xc_api_url
  f5xc_namespace           = var.f5xc_namespace
  f5xc_api_token           = var.f5xc_api_token
  f5xc_token_name          = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_fleet_label         = var.f5xc_fleet_label
  f5xc_cluster_latitude    = var.cluster_latitude
  f5xc_cluster_longitude   = var.cluster_longitude
  f5xc_ce_gateway_type     = var.f5xc_ce_gateway_type
  f5xc_is_secure_cloud_ce  = true
  providers                = {
    google   = google.default
    volterra = volterra.default
  }
}

output "gcp_ce_multi_nic_existing_vpc" {
  value = module.gcp_secure_ce_multi_nic_existing_vpc.ce
}