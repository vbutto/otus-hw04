output "frontend_public_ip" {
  value = yandex_compute_instance.vm_front.network_interface[0].nat_ip_address
}

output "backend_ip" {
  value = yandex_compute_instance.vm_back.network_interface[0].ip_address
}

output "db_ip" {
  value = yandex_compute_instance.vm_db.network_interface[0].ip_address
}

output "nat_gateway_id" {
  value = yandex_vpc_gateway.nat_gw.id
}
