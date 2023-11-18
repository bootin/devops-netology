resource "yandex_compute_disk" "empty-disk" {
  count = 3
  name = "disk${count.index}"
  type       = "network-hdd"
  zone       = var.default_zone
  size       = "1"
}


resource "yandex_compute_instance" "storage_platform" {
  depends_on  = [yandex_compute_disk.empty-disk]
  name        = "storage"
  platform_id = var.vm_platform_id
  resources {
    cores         = var.vms_resources.cores
    memory        = var.vms_resources.memory
    core_fraction = var.vms_resources.fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.empty-disk.*.id
    content {
      disk_id = secondary_disk.value
      auto_delete = true
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.vms_metadata.serial-port-enable
    ssh-keys           = "ubuntu:${local.vm_aut_ssh_key}"
  }
}
