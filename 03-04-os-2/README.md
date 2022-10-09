# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
    
    ```bash
    root@vagrant:/etc/systemd/system# ps -aux |grep node_exporter
    root       43562  0.0  1.6 726244 16396 ?        Ssl  21:42   0:00 /opt/node_exporter/node_exporter
    root       43610  0.0  0.0   6432   724 pts/1    S+   21:47   0:00 grep --color=auto node_exporter
    root@vagrant:/etc/systemd/system# systemctl stop node_exporter
    root@vagrant:/etc/systemd/system# ps -aux |grep node_exporter
    root       43626  0.0  0.0   6432   720 pts/1    S+   21:48   0:00 grep --color=auto node_exporter
    root@vagrant:/etc/systemd/system# systemctl start node_exporter
    root@vagrant:/etc/systemd/system# ps -aux |grep node_exporter
    root       43629  0.5  1.2 724580 12224 ?        Ssl  21:49   0:00 /opt/node_exporter/node_exporter
    root       43644  0.0  0.0   6432   724 pts/1    S+   21:49   0:00 grep --color=auto node_exporter
    root@vagrant:/etc/systemd/system# systemctl status node_exporter
    ● node_exporter.service - node_exporter
	Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
	Active: active (running) since Mon 2022-10-03 21:49:17 UTC; 18s ago
    Main PID: 43629 (node_exporter)
	Tasks: 4 (limit: 1066)
	Memory: 2.2M
	CGroup: /system.slice/node_exporter.service
             └─43629 /opt/node_exporter/node_exporter

    Oct 03 21:49:17 vagrant node_exporter[43629]: ts=2022-10-03T21:49:17.789Z caller=node_exporter.go:115 level=info collector=thermal_zo>
    Oct 03 21:49:17 vagrant node_exporter[43629]: ts=2022-10-03T21:49:17.790Z caller=node_exporter.go:115 level=info collector=time
    Oct 03 21:49:17 vagrant node_exporter[43629]: ts=2022-10-03T21:49:17.790Z caller=node_exporter.go:115 level=info collector=timex
    ```
    Конфигурационный файл:
    ```txt
    root@vagrant:/etc/systemd/system# cat /etc/systemd/system/node_exporter.service
    [Unit]
    Description=node_exporter

    [Service]
    EnvironmentFile=-/etc/default/node_exporter
    ExecStart=/opt/node_exporter/node_exporter $EXTRA_OPTS

    [Install]
    WantedBy=default.target
    
    ```
    Параметры можем передавать через фал `/etc/default/node_exporter` либо через `systemctl edit node_exporter`.


2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
    CPU:
    ```bash
    # TYPE node_cpu_seconds_total counter
    node_cpu_seconds_total{cpu="[cpu_id_number]",mode="idle"} 
    node_cpu_seconds_total{cpu="[cpu_id_number]",mode="system"} 
    node_cpu_seconds_total{cpu="0",mode="user"}
    # TYPE process_cpu_seconds_total counter
    process_cpu_seconds_total
    ```
    Memory:
    ```bash
    # TYPE node_memory_MemTotal_bytes gauge
    node_memory_MemTotal_bytes
    # TYPE node_memory_MemFree_bytes gauge
    node_memory_MemFree_bytes
    # TYPE node_memory_MemAvailable_bytes gauge
    node_memory_MemAvailable_bytes
    # TYPE node_memory_Cached_bytes gauge
    node_memory_Cached_bytes
    # TYPE node_memory_SwapCached_bytes gauge
    node_memory_SwapCached_bytes 
    # TYPE node_memory_SwapFree_bytes gauge
    node_memory_SwapFree_bytes 
    # TYPE node_memory_SwapTotal_bytes gauge
    node_memory_SwapTotal_bytes
    ```
    Disk:
    ```bash
    # TYPE node_disk_io_time_seconds_total counter
    node_disk_io_time_seconds_total{device="[device_name]"}
    # TYPE node_filesystem_avail_bytes gauge
    node_filesystem_avail_bytes{..}
    node_filesystem_free_bytes{..}
    node_filesystem_files_free{..}
    node_filesystem_device_error{..}
    ```
    Network:
    ```bash
    # TYPE node_network_receive_errs_total counter
    node_network_receive_errs_total{device="[device_name]"}
    # TYPE node_network_transmit_drop_total counter
    node_network_transmit_drop_total{device="[device_name]"}
    ```
    
    
3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
    
    #Установлено. После установки файл `/etc/netdata/netdata.conf` имел только секцию global, хотя при вызове с ВМ `curl  http://localhost:19999/netdata.conf` выводился полный конфиг-шаблон. Где он прятался не нашел, сбросил его в файл `curl  http://localhost:19999/netdata.conf >> /home/vagrant/netdata.cfg` и заменил им `/etc/netdata/netdata.conf`. Дальше все получилось, с метриками ознакомился.

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
    ```bash
    Система "осознает" и подгружает соответствующие драйвера, в моем случае распознало как
     dmesg -T |grep virt
    [Tue Oct  4 20:11:11 2022] CPU MTRRs all blank - virtualized system.
    [Tue Oct  4 20:11:11 2022] Booting paravirtualized kernel on KVM	#среда виртуализции
    [Tue Oct  4 20:11:26 2022] systemd[1]: Detected virtualization oracle.
    ```
    
5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
    ```txt
    Этим параметром определятся максимальное колличество файловых дескрипторов, которые может зарезервировать процесс. По умолчанию 1024*1024 (1048576).
    Достич такого параметра не получиться из-за ограничения по колличеству файловых дискрипторов для пользователя. По умолчанию 1024.
    ```
    ```bash
    root@vagrant:~$ ulimit -n
    1024
    ```
    
6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

    ```bash
    root@vagrant:/home/vagrant# unshare -f --pid --mount-proc /bin/bash
    root@vagrant:/home/vagrant# ps -aux
    USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root           1  0.0  0.3   7236  3924 pts/5    S    13:15   0:00 /bin/bash
    root           8  0.0  0.3   9080  3636 pts/5    R+   13:15   0:00 ps -aux
    root@vagrant:/home/vagrant# unshare -f --pid --mount-proc sleep 1h
    ^C
    root@vagrant:/home/vagrant# ps -aux
    USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root           1  0.0  0.4   7236  4064 pts/5    S    13:15   0:00 /bin/bash
    root          10  0.0  0.0   5476   580 pts/5    S    13:15   0:00 sleep 1h
    root          11  0.0  0.3   9080  3540 pts/5    R+   13:15   0:00 ps -aux
    ```

7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

    ```bash
    [Wed Oct  5 13:22:58 2022] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-1.scope
    ```
    По умолчанию для ползователя ограничено 3691 одновременными задачами (в случае с тестовой системой). Изменить можно так:
    ```bash
    vagrant@vagrant:~$ ulimit -u
    3691
    vagrant@vagrant:~$ ulimit -u 4000
    -bash: ulimit: max user processes: cannot modify limit: Operation not permitted
    vagrant@vagrant:~$ sudo ulimit -u 4000
    sudo: ulimit: command not found
    vagrant@vagrant:~$ sudo su
    root@vagrant:/home/vagrant#  ulimit -u 4000
    root@vagrant:/home/vagrant# ulimit -u
    4000
    vagrant@vagrant:~$ ulimit -u 
    ```