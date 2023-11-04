###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDA4aj7o9wjD+hqKdx74D0+oVSEEiWpdbvCqXgUMXhL/sOHniaRv8juoccxsR6qGZBwyzSE4GJcMGK6a0mTPY5Wzzn18NfniLdsyVPJP242NjAaR7jipCy3dKm6DZRW43nNhQGoTerPRUgUfWWZD+zO//lfUsjevf7fVHXk1OKDtVr1BqvXqIeOi0Ry9vKEQITVELww8vNgy7g4G6vKr1JtB9TUYeWfx5tNJo5UyZ92T8LhqOW4lMRGLMW4uszdNbozqCNxyE/7o1eYq9+1tc+p1mtEevCefyReUv5wHM3wdz6lEFEI78f0+/8TNGE2o8/j6ii/QWygM3ZWen2UkwWdnjmyVhpkIVLiGoer4l7C8ByfaN0zG5rerdt1lunvBnc4jQ1mvRhCMhNnxTmfT7Cuw10kXuL5CcPvq0gtK6fagwO7CAAn3qDLJN1VMMkCrOaPsYlrQUu53exJEeGDpBoNW6nqfCUR/8tSM7BIBEPD2uuZ5JbGBXqrC6zi9QRnQFNrJR6YGTjvezXHEZduvEPLRmUmiBVgzFMywD9TnW6qIhqa2nrvugRrQxPWaghszXQDwTACioNNcMX47Cr9W/Wpfy02OtL8JNpfqkmvp23b4MTq5Lfav9buGvz+3AFx8FgRSQkKLD8FKvWuOyYd9aEEQp7BjXHHWfMSFKZ/UBX6pQ== terraform-yc"
  description = "ssh-keygen -t ed25519"
}

variable "image_name" {
type = string
description = "ubuntu release name"
default = "ubuntu-2004-lts"
}

variable "vm_web_name" {
type = string
description = "netology develop VM name"
default = "netology-develop-platform-web"
}

variable "vm_web_platform_id" {
type = string
description = "what YC platform to use"
default = "standard-v1"
}

variable "vm_web_cores" {
type = number
description = "How mach cores to use"
default = 2
}

variable "vm_web_memory" {
type = number
description = "How mach memory to use "
default = 1
}

variable "vm_web_core_fraction" {
type = number
description = "How mach cores to use"
default = 5
}


