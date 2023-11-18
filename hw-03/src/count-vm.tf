###count loop

resource "yandex_compute_instance" "web_platform" {
  count = 2
  name        = "web-${count.index + 1}"
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
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.vms_metadata.serial-port-enable
    ssh-keys           = var.vms_metadata.ssh-keys
  }

}
