

locals {
vm_web_name_local = "netology-${ var.env }-${ var.project }-${var.role[0]}"
vm_db_name_local = "netology-${ var.env }-${ var.project }-${var.role[1]}"
}

