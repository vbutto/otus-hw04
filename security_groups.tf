# FRONTEND: 80/tcp снаружи + SSH с вашего IP
resource "yandex_vpc_security_group" "sg_front" {
  name       = "sg-frontend"
  network_id = yandex_vpc_network.net.id

  ingress {
    protocol       = "TCP"
    description    = "HTTP from Internet"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "SSH from my IP"
    port           = 22
    v4_cidr_blocks = [var.my_ip]
  }

  egress {
    protocol       = "ANY"
    description    = "Any egress"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# BACKEND: доступен ТОЛЬКО с frontend SG на 3000/tcp. Egress — в Интернет (через NAT) и в частную сеть.
resource "yandex_vpc_security_group" "sg_back" {
  name       = "sg-backend"
  network_id = yandex_vpc_network.net.id

  ingress {
    protocol          = "TCP"
    description       = "App from FRONTEND only"
    port              = 3000
    security_group_id = yandex_vpc_security_group.sg_front.id
  }

  egress {
    protocol       = "ANY"
    description    = "Any egress (NAT will be used)"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# DB: доступна ТОЛЬКО с backend SG на 6000/tcp.
resource "yandex_vpc_security_group" "sg_db" {
  name       = "sg-db"
  network_id = yandex_vpc_network.net.id

  ingress {
    protocol          = "TCP"
    description       = "DB port from BACKEND only"
    port              = 6000
    security_group_id = yandex_vpc_security_group.sg_back.id
  }

  egress {
    protocol       = "ANY"
    description    = "Responses/egress inside VPC"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
