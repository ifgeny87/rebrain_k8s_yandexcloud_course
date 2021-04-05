## Yandex.Cloud
variable "yc_token" {
  type = string
  description = "Yandex Cloud API key"
}
variable "yc_region" {
  type = string
  description = "Yandex Cloud Region (i.e. ru-central1-a)"
}
variable "yc_cloud_id" {
  type = string
  description = "Yandex Cloud id"
}
variable "yc_folder_id" {
  type = string
  description = "Yandex Cloud folder id"
}

#-----

# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.48.0" # Актуально на момент составления данной статьи, актуальную версию необходимо проверять в доккументации
    }
  }
}

// Configure the Yandex.Cloud provider
provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_region
}

// Create a new instance
//resource "yandex_compute_instance" "default" {
// boot_disk =
// network_interface =
// resources =
//}
