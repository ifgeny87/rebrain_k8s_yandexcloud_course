resource "yandex_vpc_network" "internal" {
  name = "internal-work"
}

resource "yandex_vpc_subnet" "internal-a" {
  name           = "internal-work-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.internal.id
  v4_cidr_blocks = ["10.123.0.0/16"]
}

resource "yandex_vpc_subnet" "internal-b" {
  name           = "internal-work-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.internal.id
  v4_cidr_blocks = ["10.124.0.0/16"]
}

resource "yandex_vpc_subnet" "internal-c" {
  name           = "internal-work-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.internal.id
  v4_cidr_blocks = ["10.125.0.0/16"]
}
