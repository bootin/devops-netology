### **for_each loop**

resource "yandex_compute_instance" "redundancy_platform" {
  depends_on = [yandex_compute_instance.web_platform]
  for_each = {for vm in var.vm_resources_for_each: vm.vm_name => vm}
  name        = each.value.vm_name
  platform_id = var.vm_platform_id
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = each.value.disk
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

