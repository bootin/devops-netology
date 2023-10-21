# Домашнее задание к занятию 3. «MySQL»

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/blob/virt-11/additional/README.md).

## Задача 1

Используя Docker, поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
```bash
sudo docker run --name mysql_8 -v "/home/bootini/projects/devops-netology/06-db-03-mysql/src/data:/var/lib/mysql" -v "/home/bootini/projects/devops-netology/06-db-03-mysql/src/backup:/tmp/backup" -e MYSQL_ALLOW_EMPTY_PASSWORD=yes mysql:8

```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-03-mysql/test_data) и 
восстановитесь из него.
```bash
sudo docker exec -it mysql_8 bash
mysql -e 'create database test_db;'
mysql test_db < /tmp/backup/test_dump.sql
```

Перейдите в управляющую консоль `mysql` внутри контейнера.
```bash
msql
```

Используя команду `\h`, получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из её вывода версию сервера БД.
```sql
mysql> \s;
--------------
mysql  Ver 8.0.34 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		13
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.34 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			18 min 57 sec

Threads: 2  Questions: 20  Slow queries: 0  Opens: 139  Flush tables: 3  Open tables: 58  Queries per second avg: 0.017
--------------
```
Версия: `mysql  Ver 8.0.34 for Linux on x86_64 (MySQL Community Server - GPL)`

Подключитесь к восстановленной БД и получите список таблиц из этой БД.
```sql
mysql> connect test_db;
mysql> show tables;
```

**Приведите в ответе** количество записей с `price` > 300.
```sql
mysql> SELECT count(*) FROM orders WHERE price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

В следующих заданиях мы будем продолжать работу с этим контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля — 180 дней 
- количество попыток авторизации — 3 
- максимальное количество запросов в час — 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James".
```sql
mysql> CREATE USER 'test' IDENTIFIED WITH mysql_native_password BY 'test-pass' WITH MAX_QUERIES_PER_HOUR 100 PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 ATTRIBUTE '{"surname": "Pretty", "name": "James"}';
```

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
```sql
GRANT SELECT on test_db.* TO test;
```
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES, получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
```sql
SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user = 'test';
+------+------+----------------------------------------+
| USER | HOST | ATTRIBUTE                              |
+------+------+----------------------------------------+
| test | %    | {"name": "James", "surname": "Pretty"} |
+------+------+----------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.
```sql
mysql> SHOW TABLE STATUS WHERE name = 'orders'\G;
*************************** 1. row ***************************
           Name: orders
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 5
 Avg_row_length: 3276
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 6
    Create_time: 2023-10-21 20:08:59
    Update_time: NULL
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.00 sec)
```
Используется `Engine: InnoDB`

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`,
```sql
mysql> ALTET TABLE orders engine = MyISAM;
mysql> SHOW PROFILE FOR QUERY 3;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000084 |
| Executing hook on transaction  | 0.000010 |
| starting                       | 0.000021 |
| checking permissions           | 0.000007 |
| checking permissions           | 0.000007 |
| init                           | 0.000016 |
| Opening tables                 | 0.000401 |
| setup                          | 0.000137 |
| creating table                 | 0.000813 |
| waiting for handler commit     | 0.000013 |
| waiting for handler commit     | 0.007709 |
| After create                   | 0.000545 |
| System lock                    | 0.000013 |
| copy to tmp table              | 0.000117 |
| waiting for handler commit     | 0.000011 |
| waiting for handler commit     | 0.000014 |
| waiting for handler commit     | 0.000037 |
| rename result table            | 0.000079 |
| waiting for handler commit     | 0.033773 |
| waiting for handler commit     | 0.000027 |
| waiting for handler commit     | 0.004725 |
| waiting for handler commit     | 0.000022 |
| waiting for handler commit     | 0.013569 |
| waiting for handler commit     | 0.000018 |
| waiting for handler commit     | 0.004124 |
| end                            | 0.017873 |
| query end                      | 0.017924 |
| closing tables                 | 0.000029 |
| waiting for handler commit     | 0.000049 |
| freeing items                  | 0.000040 |
| cleaning up                    | 0.000035 |
+--------------------------------+----------+
31 rows in set, 1 warning (0.00 sec)
```
- на `InnoDB`.
```sql
mysql> ALTET TABLE orders engine = InnoDB;
mysql> SHOW PROFILE FOR QUERY 5;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000137 |
| Executing hook on transaction  | 0.000019 |
| starting                       | 0.000047 |
| checking permissions           | 0.000019 |
| checking permissions           | 0.000015 |
| init                           | 0.000027 |
| Opening tables                 | 0.000366 |
| setup                          | 0.000109 |
| creating table                 | 0.000166 |
| After create                   | 0.048736 |
| System lock                    | 0.000030 |
| copy to tmp table              | 0.000212 |
| rename result table            | 0.002179 |
| waiting for handler commit     | 0.000027 |
| waiting for handler commit     | 0.008348 |
| waiting for handler commit     | 0.000025 |
| waiting for handler commit     | 0.034121 |
| waiting for handler commit     | 0.000031 |
| waiting for handler commit     | 0.014500 |
| waiting for handler commit     | 0.000027 |
| waiting for handler commit     | 0.004576 |
| end                            | 0.000895 |
| query end                      | 0.003661 |
| closing tables                 | 0.000020 |
| waiting for handler commit     | 0.000050 |
| freeing items                  | 0.000050 |
| cleaning up                    | 0.000041 |
+--------------------------------+----------+
27 rows in set, 1 warning (0.00 sec)
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

- скорость IO важнее сохранности данных;
- нужна компрессия таблиц для экономии места на диске;
```sql
mysql> ALTER TAable orders  ROW_FORMAT=COMPRESSED;
```
- размер буффера с незакомиченными транзакциями 1 Мб;
- буффер кеширования 30% от ОЗУ;
- размер файла логов операций 100 Мб.

Приведите в ответе изменённый файл `my.cnf`.

```txt
[mysqld]
skip-host-cache
skip-name-resolve
secure-file-priv= NULL

innodb_flush_log_at_trx_commit = 0 
innodb_file_per_table = 1
autocommit = 0
innodb_log_buffer_size	= 1M
key_buffer_size = 2448М
max_binlog_size	= 100M
```

---


