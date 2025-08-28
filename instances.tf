locals {
  ssh_key = trimspace(file(var.ssh_public_key_path))
}

# FRONTEND (public IP, порт 80)
resource "yandex_compute_instance" "vm_front" {
  name        = "vm-frontend"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.sub_front.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg_front.id]
  }

  metadata = {
    ssh-keys           = "ubuntu:${local.ssh_key}"
    serial-port-enable = 1
    user-data          = templatefile("${path.module}/cloud-init.tpl", { role = "FRONTEND", port = 80 })
  }
}

# BACKEND (private, через NAT, порт 3000)
resource "yandex_compute_instance" "vm_back" {
  name        = "vm-backend"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.sub_back.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.sg_back.id]
  }

  metadata = {
    ssh-keys           = "ubuntu:${local.ssh_key}"
    serial-port-enable = 1
    user-data          = templatefile("${path.module}/cloud-init.tpl", { role = "BACKEND", port = 3000 })
  }
}

# DB (private, без интернета, порт 6000)
resource "yandex_compute_instance" "vm_db" {
  name        = "vm-db"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.sub_db.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.sg_db.id]
  }

  metadata = {
    ssh-keys           = "ubuntu:${local.ssh_key}"
    serial-port-enable = 1
    user-data          = templatefile("${path.module}/cloud-init.tpl", { role = "DATABASE", port = 6000 })
  }
}
