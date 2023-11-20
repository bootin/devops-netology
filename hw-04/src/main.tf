/*resource "yandex_vpc_network" "develop" {
  //name = var.vpc_name
  name = module.vpc_dev.vpc_network_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = module.vpc_dev.vpc_network_name
  zone           = var.default_zone
  //network_id     = yandex_vpc_network.develop.id
  network_id = module.vpc_dev.vpc_network_id
  v4_cidr_blocks = var.default_cidr
}*/
module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop"
  //network_id     = yandex_vpc_network.develop.id
  network_id     = module.vpc_dev.vpc_network_id
  subnet_zones   = ["ru-central1-a"]
  //subnet_ids     = [yandex_vpc_subnet.develop.id]
  subnet_ids     = [module.vpc_dev.vpc_subnet_id]
  instance_name  = "web"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }
}

module "vpc_dev" {
  #path to folder or file??
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
  token = var.token
}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    username           = var.username
    ssh_public_key     = local.vm_aut_ssh_key
    //packages           = jsonencode(var.packages)
  }
}