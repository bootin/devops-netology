# Домашнее задание к занятию 5. «Оркестрация кластером Docker контейнеров на примере Docker Swarm»

## Как сдавать задания

Обязательны к выполнению задачи без звёздочки. Их нужно выполнить, чтобы получить зачёт и диплом о профессиональной переподготовке.

Задачи со звёдочкой (*) — это дополнительные задачи и/или задачи повышенной сложности. Их выполнять не обязательно, но они помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в GitHub-репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---


## Важно

1. Перед отправкой работы на проверку удаляйте неиспользуемые ресурсы.
Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.
Подробные рекомендации [здесь](https://github.com/netology-code/virt-homeworks/blob/virt-11/r/README.md).

2. [Ссылки для установки открытого ПО](https://github.com/netology-code/devops-materials/blob/master/README.md).

---

## Задача 1

Дайте письменые ответы на вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm-кластере: replication и global?
```txt
Режим global подразумевает запуск единственного экземпляра сервиса, которому будет доступны все ноды кластера для своего развертывания.
Режим replication позволет запускать несколько екземпляров сервиса на всех нодах кластера 
```
- Какой алгоритм выбора лидера используется в Docker Swarm-кластере?
```txt
Используется алгоритм поддержания распределенного консенсуса — Raft. Консенсус предполагает согласование значений несколькими серверами.
Как только они примут решение о значении, это решение станет окончательным.
```
- Что такое Overlay Network?
```txt
Overlay Network — общий случай логической сети, создаваемой поверх другой сети. Узлы оверлейной сети могут быть связаны либо физическим
соединением, либо логическим, для которого в основной сети существуют один или несколько соответствующих маршрутов из физических
соединений.
```


## Задача 2

Создайте ваш первый Docker Swarm-кластер в Яндекс Облаке.

Чтобы получить зачёт, предоставьте скриншот из терминала (консоли) с выводом команды:
```
docker node ls
```

```bash
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
sfb0ffznyvfpg57chw4gslqj7 *   node01.netology.yc   Ready     Active         Reachable        23.0.1
1wxe16y94agnlrq881o1uaqma     node02.netology.yc   Ready     Active         Leader           23.0.1
zv4caok8oarifcuwlfoz799l4     node03.netology.yc   Ready     Active         Reachable        23.0.1
snmpwl6pj84la5vb1c7v3o45r     node04.netology.yc   Ready     Active                          23.0.1
orzzpcfaa605o6hke3fucsq4c     node05.netology.yc   Ready     Active                          23.0.1
n76i9ouc3q12wfhxjsgp1489e     node06.netology.yc   Ready     Active                          23.0.1

```

## Задача 3

Создайте ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Чтобы получить зачёт, предоставьте скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```
```bash
[centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                         PORTS
0jxt9yohrip3   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0   
4xeomr6lxftn   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                        
px5giq6h3828   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                     
08aqhqrx3y9q   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4  
```

## Задача 4 (*)

Выполните на лидере Docker Swarm-кластера команду, указанную ниже, и дайте письменное описание её функционала — что она делает и зачем нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```
```txt
Мы блокируем ключ шифрования Роя используемый для шифрования логов, а так же общий ключ TLS, становимся его владельцем. После
перезагрузки Docker необходимо разблокировать Рой. Комманда для разблакироваки:
docker swarm unlock
```

