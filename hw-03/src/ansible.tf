resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",

    { webservers =  yandex_compute_instance.web_platform,
    databases =  yandex_compute_instance.redundancy_platform,
    storage = [yandex_compute_instance.storage_platform]   })

  filename = "${abspath(path.module)}/hosts.cfg"
}