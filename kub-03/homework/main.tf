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
variable "ssh_public_cert" {
  type = string
  description = "PEM-encoded public certificate that is the root of trust for the Kubernetes cluster"
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

# Configure the Yandex.Cloud provider
provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_region
}

# Create a new instance
# Экспериментальный блок, пока что не работает как надо
resource "yandex_compute_instance" "default" {
  name = "terraform-instance1"

  resources {
    cores = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83bj827tp2slnpp7f0"
    }
  }

  network_interface {
//    subnet_id = yandex_vpc_network.internal.subnet_ids[0]
    subnet_id = yandex_vpc_subnet.internal-c.id
    nat = true
  }

  metadata = {
    # сюда можно подставить публичный ключ напрямую из файла
    # например: `ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"`
    # либо вставить из приватной переменной содержимое файла id_rsa.pub
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
