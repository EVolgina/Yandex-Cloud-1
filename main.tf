# Создание сети
resource "yandex_vpc_network" "my_network" {
  name = var.vpc_name
  folder_id = var.folder_id
}

# Создание публичной подсети
resource "yandex_vpc_subnet" "public_subnet" {
  name           = "public"
  network_id     = yandex_vpc_network.my_network.id
  v4_cidr_blocks = var.default_cidr
}

# Создание NAT-инстанса
resource "yandex_compute_instance" "nat_instance" {
  name = var.nat_name
  zone = var.default_zone

  boot_disk {
    initialize_params {
      image_id = var.nat_image
    }
  }

  resources {
    cores   = var.nat_resources.cores
    memory  = var.nat_resources.memory
  }

  network_interface {
    subnet_id       = yandex_vpc_subnet.public_subnet.id
    nat             = true
    nat_ip_address  = ""
  }
  metadata = {
    ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_ed25519.pub")}"
  }
}
# Создание публичной виртуальной машины
resource "yandex_compute_instance" "public_instance" {
  name        = var.public_name
  zone        = var.default_zone

  boot_disk {
    initialize_params {
      image_id = var.public_image
    }
  }

  resources {
    cores   = var.public_resources.cores
    memory  = var.public_resources.memory
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet.id
    nat       = true
  }
  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_ed25519.pub")}"
  }
}
# Создание приватной подсети
resource "yandex_vpc_subnet" "private_subnet" {
  name           = "private"
  network_id     = yandex_vpc_network.my_network.id
  v4_cidr_blocks = var.default_cidr_private
}

# Создание таблицы маршрутизации для приватной подсети
resource "yandex_vpc_route_table" "private_route_table" {
  name = "private_route_table"
  network_id = yandex_vpc_network.my_network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address  = yandex_compute_instance.nat_instance.network_interface.0.ip_address
  }
}

# Создание приватной виртуальной машины
resource "yandex_compute_instance" "private_instance" {
  name = var.private_name
  zone = var.default_zone

  boot_disk {
    initialize_params {
      image_id = var.private_image
    }
  }

  resources {
    cores   = var.private_resources.cores
    memory  = var.private_resources.memory
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_subnet.id
  }
  metadata = {
    ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_ed25519.pub")}"
  }
}
