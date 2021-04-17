# Создаем кластер кубернетес
resource "yandex_kubernetes_cluster" "kuber-cluster" {
  # Указываем его имя
  name        = "kub-work"

  # Указываем, к какой сети он будет подключен
  network_id = yandex_vpc_network.internal.id

  master {
    # Указываем, что мастера располагаются в регионе ru-central и какие subnets использовать для каждой зоны
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.internal-a.zone
        subnet_id = yandex_vpc_subnet.internal-a.id
      }

      location {
        zone      = yandex_vpc_subnet.internal-b.zone
        subnet_id = yandex_vpc_subnet.internal-b.id
      }

      location {
        zone      = yandex_vpc_subnet.internal-c.zone
        subnet_id = yandex_vpc_subnet.internal-c.id
      }
    }

    # Указываем версию Kubernetes
    version   = "1.18"
    # Назначаем внешний ip master нодам, чтобы мы могли подключаться к ним извне
    public_ip = true

    maintenance_policy {
      auto_upgrade = false
    }
  }

  # Указываем канал обновлений
  release_channel = "REGULAR"

  # Указываем сервисные аккаунты, которые будут использовать ноды и кластер для управления нодами
  node_service_account_id = yandex_iam_service_account.docker-registry.id
  service_account_id      = yandex_iam_service_account.instances-editor.id

  kms_provider {
    key_id = yandex_kms_symmetric_key.kms_symmetric.id
  }
}

# Создаем группу узлов
resource "yandex_kubernetes_node_group" "node-group" {
  # Указываем, к какому кластеру они принадлежат
  cluster_id  = yandex_kubernetes_cluster.kuber-cluster.id
  # Указываем название группы узлов
  name        = "node-group-0"
  # И версию kubelet
  version     = "1.18"

  # Настраиваем шаблон виртуальной машины
  instance_template {
    platform_id = "standard-v2"
    nat         = true

    resources {
      core_fraction = 20 # Данный параметр позволяет уменьшить производительность CPU и сильно уменьшить затраты на инфраструктуру
      memory        = 2
      cores         = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      # Является ли ВМ прерываемой
      preemptible = false
    }
  }

  scale_policy {
    # Политика автомасштабирования
    fixed_scale {
      size = 2
    }
  }

  # В каких зонах можно создавать машинки
  allocation_policy {
    location {
      zone = "ru-central1-a"
    }

    location {
      zone = "ru-central1-b"
    }

    location {
      zone = "ru-central1-c"
    }
  }

  # Отключаем автоматический апгрейд
  maintenance_policy {
    # Отключаем автоматический апгрейд
    auto_upgrade = false
    # Включаем автоматическое восстановление нод в случае проблем
    auto_repair  = true
  }
}
