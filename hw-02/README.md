# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav).
2. Запросите preview-доступ к этому функционалу в личном кабинете Yandex Cloud. Обычно его выдают в течение 24-х часов.
https://console.cloud.yandex.ru/folders/<ваш cloud_id>/vpc/security-groups.   
Этот функционал понадобится к следующей лекции. 

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.  Убедитесь что ваша версия **Terraform** =1.5.5 (версия 1.6 может вызывать проблемы с Яндекс провайдером) 

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные: идентификаторы облака, токен доступа. Благодаря .gitignore этот файл не попадёт в публичный репозиторий. **Вы можете выбрать иной способ безопасно передать секретные данные в terraform.**
3. Сгенерируйте или используйте свой текущий ssh-ключ. Запишите его открытую часть в переменную **vms_ssh_root_key**.
4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
```txt
Опечатка в парамере platform_id, корректное значение - "standard-v1"
Также в блоке "resources", параметр "cores" в данной платформе yadnex доступен в значении 2 или 4
```
5. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ. Ответ в документации Yandex Cloud.
```txt
preemptible = true - Указывает на то что создается прерываемая ВМ, которая самоостановиться через время (от 22ч до 24ч). В процессе обучения пригодится для экономии средст, если забыть выключить или удалить ВМ. Конечно не удалит, но хотябы выключит, что будет стоить дешевле.
core_fraction = 5 - Уровне производительности 5% ВМ будет иметь доступ к физическим ядрам как минимум 5% времени — 50 миллисекунд в течение каждой секунды. Применимо для не требовательных к задержкам приложений. Пригодится для экономии, т.к. такие машины обойдутся дешевле. 
```

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ;
![ЛК Yandex Clou](https://github.com/bootin/devops-netology/blob/main/hw-02/src/vm.png)
- скриншот успешного подключения к консоли ВМ через ssh. К OS ubuntu необходимо подключаться под пользователем ubuntu: "ssh ubuntu@vm_ip_address";
![ВМ через ssh](https://github.com/bootin/devops-netology/blob/main/hw-02/src/ssh.png)
- ответы на вопросы.


### Задание 2

1. Изучите файлы проекта.
2. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 
```bash
$ terraform plan
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpsjer5au91skthkq01]
data.yandex_compute_image.ubuntu: Read complete after 2s [id=fd8s2aj0vfge6ucq5q96]
yandex_vpc_subnet.develop: Refreshing state... [id=e9bcqf9p9u1m3st52mm4]
yandex_compute_instance.platform: Refreshing state... [id=fhmksgq4vsn3fdqos09u]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and
found no differences, so no changes are needed.
```

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  cores  = 2, memory = 2, core_fraction = 20. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').
3. Примените изменения.
```txt
Приложены файлы к проекту на git
```

### Задание 4

1. Объявите в файле outputs.tf output типа map, содержащий { instance_name = external_ip } для каждой из ВМ.
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.
```bash
$ terraform output 
db_platform = "51.250.72.16"
platform = "51.250.93.196"
```


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local-переменные.
3. Примените изменения.
```txt
locals {
vm_web_name_local = "netology-${ var.env }-${ var.project }-${var.role[0]}"
vm_db_name_local = "netology-${ var.env }-${ var.project }-${var.role[1]}"
}

...
name        = local.vm_db_name_local
...
name        = local.vm_web_name_local
...
```
```bash
$ terraform apply
...
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources". В качестве продвинутой практики попробуйте создать одну map-переменную **vms_resources** и уже внутри неё конфиги обеих ВМ — вложенный map.
2. Также поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.
3. Найдите и удалите все более не используемые переменные проекта.
4. Проверьте terraform plan. Изменений быть не должно.
```txt
variable "vms_resources" {
  type = map(map(number))
  default = {
    vm_web_resources = {
      cores = 2
      memory = 1
      fraction = 5
    }
    vm_db_resources = {
      cores = 2
      memory = 2
      fraction = 20
    }
  }
}

variable "vms_metadata" {
  type = map(string)
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDA4aj7o9wjD+hqKdx74D0+oVSEEiWpdbvCqXgUMXhL/sOHniaRv8juoccxsR6qGZBwyzSE4GJcMGK6a0mTPY5Wzzn18NfniLdsyVPJP242NjAaR7jipCy3dKm6DZRW43nNhQGoTerPRUgUfWWZD+zO//lfUsjevf7fVHXk1OKDtVr1BqvXqIeOi0Ry9vKEQITVELww8vNgy7g4G6vKr1JtB9TUYeWfx5tNJo5UyZ92T8LhqOW4lMRGLMW4uszdNbozqCNxyE/7o1eYq9+1tc+p1mtEevCefyReUv5wHM3wdz6lEFEI78f0+/8TNGE2o8/j6ii/QWygM3ZWen2UkwWdnjmyVhpkIVLiGoer4l7C8ByfaN0zG5rerdt1lunvBnc4jQ1mvRhCMhNnxTmfT7Cuw10kXuL5CcPvq0gtK6fagwO7CAAn3qDLJN1VMMkCrOaPsYlrQUu53exJEeGDpBoNW6nqfCUR/8tSM7BIBEPD2uuZ5JbGBXqrC6zi9QRnQFNrJR6YGTjvezXHEZduvEPLRmUmiBVgzFMywD9TnW6qIhqa2nrvugRrQxPWaghszXQDwTACioNNcMX47Cr9W/Wpfy02OtL8JNpfqkmvp23b4MTq5Lfav9buGvz+3AFx8FgRSQkKLD8FKvWuOyYd9aEEQp7BjXHHWfMSFKZ/UBX6pQ== terraform-yc"
  }
}
```

------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

В качестве решения предоставьте необходимые команды и их вывод.

------
### Правила приёма работы

В git-репозитории, в котором было выполнено задание к занятию «Введение в Terraform», создайте новую ветку terraform-02, закоммитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-02.

В качестве результата прикрепите ссылку на ветку terraform-02 в вашем репозитории.

**Важно. Удалите все созданные ресурсы**.


### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 

