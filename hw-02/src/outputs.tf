output "platform" {
value = yandex_compute_instance.platform.network_interface.0.nat_ip_address
description = "vm external ip"
}

output "db_platform" {
value = yandex_compute_instance.db_platform.network_interface.0.nat_ip_address
description = "vm external ip"
}

