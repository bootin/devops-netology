terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

locals {
  labels = length(keys(var.labels)) >0 ? var.labels: {
    env     =var.env_name
    project ="undefined"
  }
}

//resource "yandex_vpc_network" "develop" {
resource "yandex_vpc_network" "develop_vpc" {
  name = var.env_name
}
//resource "yandex_vpc_subnet" "develop" {
resource "yandex_vpc_subnet" "develop_vpc" {
  //name           = var.vpc_name
  name = var.env_name
  zone           = var.zone
  network_id     = yandex_vpc_network.develop_vpc.id
  //v4_cidr_blocks = var.default_cidr
  v4_cidr_blocks = [var.cidr]
}