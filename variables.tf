variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "02"
}

variable "project_name" {
  type    = string
  default = "gcp-ce"
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "ssh_public_key_file" {
  type = string
}

variable "gcp_region" {
  type    = string
  default = "us-east1"
  # default = "us-east4"
}

variable "gcp_zone" {
  type    = string
  default = "us-east1-b"
  # default = "us-east4-b
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_application_credentials" {
  type = string
}

variable "cluster_latitude" {
  type    = string
  default = "39.8282"
}

variable "cluster_longitude" {
  type    = string
  default = "-98.5795"
}

variable "fabric_subnet_outside" {
  type    = string
  default = "192.168.0.0/25"
}

variable "fabric_subnet_inside" {
  type    = string
  default = "192.168.0.128/25"
}

variable "machine_image" {
  type = object({
    asia = object({
      ingress_gateway        = string
      ingress_egress_gateway = string
    }),
    us = object({
      ingress_gateway        = string
      ingress_egress_gateway = string
    }),
    eu = object({
      ingress_gateway        = string
      ingress_egress_gateway = string
    })
  })
  default = {
    asia = {
      ingress_gateway        = "centos7-atomic-20220721105-single-voltmesh-asia"
      ingress_egress_gateway = "centos7-atomic-20220721105-multi-voltmesh-asia"
    },
    us = {
      ingress_gateway        = "centos7-atomic-20220721105-single-voltmesh-us"
      # ingress_egress_gateway = "centos7-atomic-20220721105-multi-voltmesh-us"
      ingress_egress_gateway = "centos7-atomic-20220721105-multi-voltmesh-davita-from-public"

    },
    eu = {
      ingress_gateway        = "centos7-atomic-20220721105-single-voltmesh-eu"
      ingress_egress_gateway = "centos7-atomic-20220721105-multi-voltmesh-eu"
    }
  }
}

/*variable "machine_image" {
  type = object({
    ingress_gateway        = string
    ingress_egress_gateway = string
  })
  default = {
    ingress_gateway        = "centos7-atomic-20220721105-single-voltmesh"
    # ingress_egress_gateway = "centos7-atomic-20220721105-multi-voltmesh-davita"
    # ingress_egress_gateway = "centos7-atomic-20220721105-multi-voltmesh-davita-from-public"
    ingress_egress_gateway = "centos7-atomic-20220721105-multi-voltmesh-davita-from-s-team"
    # ingress_egress_gateway = "centos7-atomic-202010061048-multi-voltmesh-davita"
  }
}*/

variable "machine_type" {
  type    = string
  default = "n1-standard-4"
}

variable "machine_disk_size" {
  type    = string
  default = "40"
}

variable "f5xc_ce_gateway_type" {
  type    = string
  default = "ingress_egress_gateway"
  # default = "ingress_gateway"
}

variable "f5xc_ce_image_source_url" {
  type    = string
  default = "https://storage.googleapis.com/ves-images"
}

variable "f5xc_ce_image_file_name_suffix" {
  type    = string
  default = ".tar.gz"
}

variable "f5xc_fleet_label" {
  type    = string
  default = "gcp-ce-test"
}

locals {
  cluster_labels = var.f5xc_fleet_label != "" ? { "ves.io/fleet" = var.f5xc_fleet_label } : {}
}

provider "google" {
  credentials = file(var.gcp_application_credentials)
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
  alias       = "default"
}

provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  alias        = "default"
}

