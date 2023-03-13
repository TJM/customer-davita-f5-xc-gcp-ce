module "gcp_secure_ce_multi_nic_existing_vpc" {
  source                         = "./modules/f5xc/ce/gcp"
  is_sensitive                   = false
  gcp_region                     = var.gcp_region
  machine_type                   = var.machine_type
  ssh_username                   = "centos"
  has_public_ip                  = false
  machine_image                  = var.machine_image["us"][var.f5xc_ce_gateway_type]
  instance_name                  = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_public_key                 = file(var.ssh_public_key_file)
  machine_disk_size              = var.machine_disk_size
  existing_fabric_subnet_outside = module.vpc_slo.subnets_ids[0]
  existing_fabric_subnet_inside  = module.vpc_sli.subnets_ids[0]
  f5xc_tenant                    = var.f5xc_tenant
  f5xc_api_url                   = var.f5xc_api_url
  f5xc_namespace                 = var.f5xc_namespace
  f5xc_api_token                 = var.f5xc_api_token
  f5xc_token_name                = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_fleet_label               = var.f5xc_fleet_label
  f5xc_cluster_latitude          = var.cluster_latitude
  f5xc_cluster_longitude         = var.cluster_longitude
  f5xc_ce_gateway_type           = var.f5xc_ce_gateway_type
  f5xc_is_secure_cloud_ce        = true
  providers                      = {
    google   = google.default
    volterra = volterra.default
  }
}

output "gcp_ce_multi_nic_existing_vpc" {
  value = module.gcp_secure_ce_multi_nic_existing_vpc.ce
}