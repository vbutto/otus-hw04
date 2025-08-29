resource "yandex_vpc_network" "net" {
  name = "net-3tier"
}

resource "yandex_vpc_subnet" "sub_front" {
  name           = "sub-frontend-public"
  zone           = var.zone
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = [var.subnet_front_cidr]
}

resource "yandex_vpc_subnet" "sub_back" {
  name           = "sub-backend-private"
  zone           = var.zone
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = [var.subnet_back_cidr]
  route_table_id = yandex_vpc_route_table.rt_nat.id # backend ходит в интернет через NAT
}

resource "yandex_vpc_subnet" "sub_db" {
  name           = "sub-db-private"
  zone           = var.zone
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = [var.subnet_db_cidr]
  # DB без интернета (нет привязки route_table_id)
}

# NAT gateway для egress-доступа приватных подсетей (региональный ресурс).
# Концепт NAT GW: даёт выход в интернет без публичных IP у ВМ. :contentReference[oaicite:3]{index=3}
resource "yandex_vpc_gateway" "nat_gw" {
  name = "nat-shared-egress"
  shared_egress_gateway {}
}

# Маршрут по умолчанию на NAT GW, привязываем к backend-подсети.
# Настройка маршрутов через Terraform: используем route table с next hop = gateway. :contentReference[oaicite:4]{index=4}
resource "yandex_vpc_route_table" "rt_nat" {
  name       = "rt-to-nat"
  network_id = yandex_vpc_network.net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gw.id
  }
}

# Образ Ubuntu 22.04 LTS (есть python3 «из коробки» — пригодится для http.server)
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}
