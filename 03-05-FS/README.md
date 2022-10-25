# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

Изучил.

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
    ```
    Нет, т.к. жесткая ссылка это ссылка на один и тот же файловый обьект и имеет один и тот же inode, что исключает установку разлмчных прав. При изиенении прав у одного обьекта, права синхронно изменяться у другого.
    ```
3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
    
    ```bash
    vagrant@vagrant:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 61.9M  1 loop /snap/core20/1328
    loop1                       7:1    0 67.2M  1 loop /snap/lxd/21835
    loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part /boot
    └─sda3                      8:3    0 62.5G  0 part
	└─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    sdc                         8:32   0  2.5G  0 disk
    ```

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

    ```bash
    fdisk /dev/sdb
    Command (m for help): n
    ...
    Select (default p): p
    Partition number (1-4, default 1):
    First sector (2048-5242879, default 2048):
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G
    ...
    Command (m for help): n
    Select (default p): p
    Partition number (1-4, default 1):
    Partition number (2-4, default 2):
    First sector (4196352-5242879, default 4196352):
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):
    ...
    w
    ...
    root@vagrant:/home/vagrant# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 61.9M  1 loop /snap/core20/1328
    loop1                       7:1    0 67.2M  1 loop /snap/lxd/21835
    loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
    loop3                       7:3    0   48M  1 loop /snap/snapd/17336
    loop4                       7:4    0 63.2M  1 loop /snap/core20/1623
    loop5                       7:5    0 67.8M  1 loop /snap/lxd/22753
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part /boot
    └─sda3                      8:3    0 62.5G  0 part
	└─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    ```

5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

    ```bash
    root@vagrant:/home/vagrant# sfdisk -d /dev/sdb > partition-sdb-dump
    root@vagrant:/home/vagrant# sfdisk /dev/sdc < partition-sdb-dump
    ...
    root@vagrant:/home/vagrant# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 61.9M  1 loop /snap/core20/1328
    loop1                       7:1    0 67.2M  1 loop /snap/lxd/21835
    loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
    loop3                       7:3    0   48M  1 loop /snap/snapd/17336
    loop4                       7:4    0 63.2M  1 loop /snap/core20/1623
    loop5                       7:5    0 67.8M  1 loop /snap/lxd/22753
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part /boot
    └─sda3                      8:3    0 62.5G  0 part
	└─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    └─sdc2                      8:34   0  511M  0 part
    ```

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

    ```bash
    root@vagrant:/home/vagrant# mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1 --metadata=0.90
    mdadm: size set to 2097088K
    mdadm: array /dev/md1 started.
    ```
    При создании рейда перепутал разделы и создал с большми разделамаи raid0. Пришлось удалять раздел. 
    ```bash
    mdadm --stop /dev/md1
    mdadm --zero-superblock /dev/sdf1 /dev/sde1
    ```
    После этого выскочило предупреждение о metadata. На всякий случай добавил `--metadata=0.90`

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

    ```bash
    root@vagrant:/home/vagrant# mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
    mdadm: chunk size defaults to 512K
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    ```

8. Создайте 2 независимых PV на получившихся md-устройствах.

    ```bash
    root@vagrant:/home/vagrant# pvcreate /dev/md0
	Physical volume "/dev/md0" successfully created.
    root@vagrant:/home/vagrant# pvcreate /dev/md1
	Physical volume "/dev/md1" successfully created.
    ```

9. Создайте общую volume-group на этих двух PV.

    ```bash
    root@vagrant:/home/vagrant# vgcreate vg-raid /dev/md0 /dev/md1
	Volume group "vg-raid" successfully created
    root@vagrant:/home/vagrant# pvdisplay
      --- Physical volume ---
      PV Name               /dev/sda3
      VG Name               ubuntu-vg
      PV Size               <62.50 GiB / not usable 0
      Allocatable           yes
      PE Size               4.00 MiB
      Total PE              15999
      Free PE               8000
      Allocated PE          7999
      PV UUID               x7S6t2-at3n-E9kU-cz28-gAH3-QU9H-vyVuNf

      --- Physical volume ---
      PV Name               /dev/md0
      VG Name               vg-raid
      PV Size               1018.00 MiB / not usable 2.00 MiB
      Allocatable           yes
      PE Size               4.00 MiB
      Total PE              254
      Free PE               254
      Allocated PE          0
      PV UUID               Qkeaxf-jbre-eo0q-vIus-ZWAx-uv11-MOmJrJ

      --- Physical volume ---
      PV Name               /dev/md1
      VG Name               vg-raid
      PV Size               <2.00 GiB / not usable <3.94 MiB
      Allocatable           yes
      PE Size               4.00 MiB
      Total PE              511
      Free PE               511
      Allocated PE          0
      PV UUID               VEPx0X-lP4I-XYop-xNt7-4rpI-441i-vluVG5
	```

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

    ```bash
    root@vagrant:/home/vagrant# lvcreate -L 100M vg-raid /dev/md0
	Logical volume "lvol0" created.
    ```

11. Создайте `mkfs.ext4` ФС на получившемся LV.

    ```bash
    root@vagrant:/home/vagrant# mkfs.ext4 /dev/vg-raid/lvol0
    mke2fs 1.45.5 (07-Jan-2020)
    Creating filesystem with 25600 4k blocks and 25600 inodes
    
    Allocating group tables: done
    Writing inode tables: done
    Creating journal (1024 blocks): done
    Writing superblocks and filesystem accounting information: done
    ```

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

    ```bash
    root@vagrant:/home/vagrant# mkdir /tmp/new
    root@vagrant:/home/vagrant# mount /dev/vg-raid/lvol0 /tmp/new
    echo "/dev/vg-raid/lvol0 /tmp/new ext4 defaults 0 1" >> /etc/fstab
    ```

13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

    ```bash
    root@vagrant:/home/vagrant# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
    --2022-10-25 15:10:15--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
    Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
    Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 22440171 (21M) [application/octet-stream]
    Saving to: ‘/tmp/new/test.gz’

    /tmp/new/test.gz                   100%[================================================================>]  21.40M  4.36MB/s    in 4.7s

    2022-10-25 15:10:20 (4.56 MB/s) - ‘/tmp/new/test.gz’ saved [22440171/22440171]
    ```

14. Прикрепите вывод `lsblk`.

    ```bash
    root@vagrant:/home/vagrant# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 61.9M  1 loop  /snap/core20/1328
    loop1                       7:1    0 63.2M  1 loop  /snap/core20/1623
    loop2                       7:2    0 67.2M  1 loop  /snap/lxd/21835
    loop3                       7:3    0 67.8M  1 loop  /snap/lxd/22753
    loop4                       7:4    0 43.6M  1 loop  /snap/snapd/14978
    loop5                       7:5    0   48M  1 loop  /snap/snapd/17336
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part  /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0
	└─vg--raid-lvol0      253:1    0  100M  0 lvm   /tmp/new
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0
	└─vg--raid-lvol0      253:1    0  100M  0 lvm   /tmp/new
    ```

15. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
    Протестировал
    ```bash
    root@vagrant:/home/vagrant# gzip -t /tmp/new/test.gz
    root@vagrant:/home/vagrant# echo $?
    0
    ```
    
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

    ```bash
    root@vagrant:/home/vagrant#  pvmove -n lvol0 /dev/md0 /dev/md1
      /dev/md0: Moved: 96.00%
    root@vagrant:/home/vagrant# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 61.9M  1 loop  /snap/core20/1328
    loop1                       7:1    0 63.2M  1 loop  /snap/core20/1623
    loop2                       7:2    0 67.2M  1 loop  /snap/lxd/21835
    loop3                       7:3    0 67.8M  1 loop  /snap/lxd/22753
    loop4                       7:4    0 43.6M  1 loop  /snap/snapd/14978
    loop5                       7:5    0   48M  1 loop  /snap/snapd/17336
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part  /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    │   └─vg--raid-lvol0      253:1    0  100M  0 lvm   /tmp/new
    └─sdb2                      8:18   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    │   └─vg--raid-lvol0      253:1    0  100M  0 lvm   /tmp/new
    └─sdc2                      8:34   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0
    ```

17. Сделайте `--fail` на устройство в вашем RAID1 md.

    ```bash
    root@vagrant:/home/vagrant# mdadm --fail /dev/md1 /dev/sdc1
    mdadm: set /dev/sdc1 faulty in /dev/md1
    ```

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

    ```bash
    root@vagrant:/home/vagrant# dmesg -T
    [Tue Oct 25 16:01:31 2022] md/raid1:md1: Disk failure on sdc1, disabling device.
                          md/raid1:md1: Operation continuing on 1 devices.
    ```

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
    
    Протестировал.
    
    ```bash
    root@vagrant:/home/vagrant# gzip -t /tmp/new/test.gz
    root@vagrant:/home/vagrant# echo $?
    0
    ```
20. Погасите тестовый хост, `vagrant destroy`.
    
    ```bash
    root@vagrant:/home/vagrant# shutdown now
    Connection to 127.0.0.1 closed by remote host.
    Connection to 127.0.0.1 closed.

    D:\vagrant-wd>vagrant destroy
	default: Are you sure you want to destroy the 'default' VM? [y/N] y
    ==> default: Destroying VM and associated drives...

    ```
 
 ---