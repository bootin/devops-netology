output "vpc_subnet_id" {
  value = yandex_vpc_subnet.develop_vpc.id
}

output "vpc_network_name" {
  value = yandex_vpc_network.develop_vpc.name
}

output "vpc_network_id" {
  value = yandex_vpc_network.develop_vpc.id
}