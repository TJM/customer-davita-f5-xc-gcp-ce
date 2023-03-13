# F5XC GCP CLOUD CE

Terraform to create F5XC GCP cloud CE

## Usage

- Clone this repo with: `git clone --recurse-submodules https://github.com/cklewar/f5-xc-gcp-ce`
- Enter repository directory with: `cd f5xc-gcp-cloud-ce`
- Obtain F5XC API certificate file from Console and save it to `cert` directory
- Pick and choose from below examples and add mandatory input data and copy data into file `main.tf.example`.
- Rename file __main.tf.example__ to __main.tf__ with: `rename main.tf.example main.tf`
- Initialize with: `terraform init`
- Apply with: `terraform apply -auto-approve` or destroy with: `terraform destroy -auto-approve`

## F5XC GCP Cloud CE single NIC module usage example

````hcl
module "gcp_ce" {
  source                     = "./modules/f5xc/ce/gcp"
  gcp_region                 = var.gcp_region
  machine_type               = var.machine_type
  network_name               = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_username               = "centos"
  machine_image              = var.machine_image
  instance_name              = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_public_key             = file(var.ssh_public_key_file)
  machine_disk_size          = var.machine_disk_size
  fabric_subnet_inside       = var.fabric_subnet_inside
  fabric_subnet_outside      = var.fabric_subnet_outside
  host_localhost_public_name = "vip"
  f5xc_tenant                = var.f5xc_tenant
  f5xc_api_url               = var.f5xc_api_url
  f5xc_namespace             = var.f5xc_namespace
  f5xc_api_token             = var.f5xc_api_token
  f5xc_token_name            = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_fleet_label           = var.f5xc_fleet_label
  f5xc_cluster_latitude      = var.cluster_latitude
  f5xc_cluster_longitude     = var.cluster_longitude
  f5xc_ce_gateway_type       = "ingress_gateway"
  providers                  = {
    google   = google.default
    volterra = volterra.default
  }
}

output "ce" {
  value = module.gcp_ce.ce
}
````

## F5XC GCP Cloud CE Multi NIC module usage example

````hcl
module "gcp_ce" {
  source                     = "./modules/f5xc/ce/gcp"
  gcp_region                 = var.gcp_region
  machine_type               = var.machine_type
  network_name               = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_username               = "centos"
  machine_image              = var.machine_image
  instance_name              = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  ssh_public_key             = file(var.ssh_public_key_file)
  machine_disk_size          = var.machine_disk_size
  fabric_subnet_inside       = var.fabric_subnet_inside
  fabric_subnet_outside      = var.fabric_subnet_outside
  host_localhost_public_name = "vip"
  f5xc_tenant                = var.f5xc_tenant
  f5xc_api_url               = var.f5xc_api_url
  f5xc_namespace             = var.f5xc_namespace
  f5xc_api_token             = var.f5xc_api_token
  f5xc_token_name            = format("%s-%s-%s", var.project_prefix, var.project_name, var.project_suffix)
  f5xc_fleet_label           = var.f5xc_fleet_label
  f5xc_cluster_latitude      = var.cluster_latitude
  f5xc_cluster_longitude     = var.cluster_longitude
  f5xc_ce_gateway_type       = "ingress_egress_gateway"
  providers                  = {
    google   = google.default
    volterra = volterra.default
  }
}

output "ce" {
  value = module.gcp_ce.ce
}
````# customer-davita-f5-xc-gcp-ce
