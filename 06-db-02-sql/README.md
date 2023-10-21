# Домашнее задание к занятию 2. «SQL»

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/blob/virt-11/additional/README.md).

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose-манифест.

```bash
sudo docker run --name postgres_1 -d -e POSTGRES_HOST_AUTH_METHOD=trust -v '/home/bootini/projects/devops-netology/06-db-02-sql/src/data:/var/lib/postgresql/data' -v '/home/bootini/projects/devops-netology/06-db-02-sql/src/backup:/tmp/backup' postgres:12
```
Комманда первого подключения
```bash
sudo docker exec -it postgres_1 psql -U postgres
``` 

## Задача 2

В БД из задачи 1: 

- создайте пользователя test-admin-user и БД test_db;
```sql
CREATE DATABASE test_db;
\c test_db
CREATE USER "test-admin-user";
```
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);
```sql
CREATE TABLE orders (id SERIAL PRIMARY KEY, name VARCHAR, price INT);
CREATE TABLE clients (id SERIAL PRIMARY KEY, name VARCHAR, country VARCHAR, zakaz_id SERIAL, FOREIGN KEY (zakaz_id) REFERENCES orders (id));
```
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;
```sql
GRANT ALL ON orders, clients TO "test-admin-user";
```
- создайте пользователя test-simple-user;
```sql
CREATE USER "test-simple-user";
```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.
```sql
GRANT SELECT,INSERT,UPDATE,DELETE ON orders, clients to "test-simple-user";
```

Таблица orders:

- id (serial primary key);
- наименование (string);
- цена (integer).

Таблица clients:

- id (serial primary key);
- фамилия (string);
- страна проживания (string, index);
- заказ (foreign key orders).

Приведите:

- итоговый список БД после выполнения пунктов выше;
```sql
test_db=# \l+
Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |                Description        
         
-----------+----------+----------+------------+------------+-----------------------+---------+------------+-----------------------------------
---------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7977 kB | pg_default | default administrative connection database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7833 kB | pg_default | unmodifiable empty database
           |          |          |            |            | postgres=CTc/postgres |         |            | 
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7833 kB | pg_default | default template for new databases
           |          |          |            |            | postgres=CTc/postgres |         |            | 
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 8129 kB | pg_default |
```
- описание таблиц (describe);
```sql
test_db=# \d+ clients
                                                         Table "public.clients"
  Column  |       Type        | Collation | Nullable |                  Default                  | Storage  | Stats target | Description 
----------+-------------------+-----------+----------+-------------------------------------------+----------+--------------+-------------
 id       | integer           |           | not null | nextval('clients_id_seq'::regclass)       | plain    |              | 
 name | character varying |           |          |                                           | extended |              | 
 country  | character varying |           |          |                                           | extended |              | 
 zakaz_id | integer           |           |          | nextval('clients_zakaz_id_seq'::regclass) | plain    |              | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_zakaz_id_fkey" FOREIGN KEY (zakaz_id) REFERENCES orders(id)
Access method: heap

test_db=# \d+ orders
                                                     Table "public.orders"
 Column |       Type        | Collation | Nullable |              Default               | Storage  | Stats target | Description 
--------+-------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer           |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
 name   | character varying |           |          |                                    | extended |              | 
 price  | integer           |           |          |                                    | plain    |              | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_zakaz_id_fkey" FOREIGN KEY (zakaz_id) REFERENCES orders(id)
Access method: heap
```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;
```sql
test_db=# SELECT grantee,table_name,privilege_type 
FROM information_schema.table_privileges
WHERE table_schema = 'public';
```
- список пользователей с правами над таблицами test_db.
```sql
     grantee      | table_name | privilege_type 
------------------+------------+----------------
 postgres         | orders     | INSERT
 postgres         | orders     | SELECT
 postgres         | orders     | UPDATE
 postgres         | orders     | DELETE
 postgres         | orders     | TRUNCATE
 postgres         | orders     | REFERENCES
 postgres         | orders     | TRIGGER
 test-admin-user  | orders     | INSERT
 test-admin-user  | orders     | SELECT
 test-admin-user  | orders     | UPDATE
 test-admin-user  | orders     | DELETE
 test-admin-user  | orders     | TRUNCATE
 test-admin-user  | orders     | REFERENCES
 test-admin-user  | orders     | TRIGGER
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
 test-simple-user | orders     | DELETE
 postgres         | clients    | INSERT
 postgres         | clients    | SELECT
 postgres         | clients    | UPDATE
 postgres         | clients    | DELETE
 postgres         | clients    | TRUNCATE
 postgres         | clients    | REFERENCES
 postgres         | clients    | TRIGGER
 test-admin-user  | clients    | INSERT
 test-admin-user  | clients    | SELECT
 test-admin-user  | clients    | UPDATE
 test-admin-user  | clients    | DELETE
 test-admin-user  | clients    | TRUNCATE
 test-admin-user  | clients    | REFERENCES
 test-admin-user  | clients    | TRIGGER
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | clients    | DELETE
(36 rows)
```

## Задача 3

Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL-синтаксис:
- вычислите количество записей для каждой таблицы.
```sql

```

Приведите в ответе:

    - запросы,
    - результаты их выполнения.
    
    Вставка занчений в таблице orders:
```sql
test_db=# INSERT INTO orders (name,price) VALUES ('Шоколад',10), ('Принтер',3000),
('Книга',500), ('Монитор',7000), ('Гитара',4000);
INSERT 0 5
```
    Вставка занчений в clients:
```sql
test_db=# INSERT INTO clients (name,country,zakaz_id) VALUES
('Иванов Иван Иванович','USA',NULL), ('Петров Петр Петрович','Canada',NULL),
('Иоганн Себастьян Бах','Japan',NULL), ('Ронни Джеймс Дио','Russia',NULL),
('Ritchie Blackmore','Russia',NULL);
INSERT 0 5
```
    Количество строк в талице orders:
```sql
test_db=# select count(*) from orders;
 count 
-------
     5
(1 row)
```
    Количество строк в талице clients:
```sql
test_db=# select count(*) from clients;
 count 
-------
     5
(1 row)

```
    


## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys, свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения этих операций.
```sql
UPDATE clients
SET zakaz_id = (SELECT id FROM orders WHERE name = 'Книга')
WHERE name = 'Иванов Иван Иванович';

UPDATE clients
SET zakaz_id = (SELECT id FROM orders WHERE name = 'Монитор')
WHERE name = 'Петров Петр Петрович';

UPDATE clients
SET zakaz_id = (SELECT id FROM orders WHERE name = 'Гитара')
WHERE name = 'Иоганн Себастьян Бах';
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.
```sql
SELECT id, name, country FROM clients where zakaz_id IS NOT NULL;

 id |       name       | country 
----+----------------------+---------
  2 | Иванов Иван Иванович | USA
  3 | Петров Петр Петрович | Canada
  4 | Иоганн Себастьян Бах | Japan
(3 rows)
```
 
Подсказка: используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните, что значат полученные значения.
```sql
test_db=# EXPLAIN SELECT id, name, country FROM clients where zakaz_id IS NOT NULL;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=68)
   Filter: (zakaz_id IS NOT NULL)
(2 rows)
```
`Seq Scan` - План простого последовательного сканирования. 
`cost=0.00` - Приблизительная стоимость запуска. Это время, которое проходит, прежде чем начнётся этап вывода данных.
`..18.10` - Приблизительная общая стоимость. Она вычисляется в предположении, что узел плана выполняется до конца, то есть возвращает все доступные строки. Родительский узел может досрочно прекратить чтение строк дочернего.
`rows=806` - Ожидаемое число строк, которое должен вывести этот узел плана. При этом так же предполагается, что узел выполняется до конца.
`width=68` - Ожидаемый средний размер строк, выводимых этим узлом плана (в байтах).
`Filter: (zakaz_id IS NOT NULL)` - Говорит о применении фильтра к узлу плана. В скобочках указывается какой именно фильтр (условие) применялся.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).
`Бекап ролей:`
```sql
sudo docker exec -it postgres_1 pg_dumpall -U postgres --roles-only -f /tmp/backup/roles.sql
```
`Бекап базы test_db:`
```sql
sudo docker exec -it postgres_1 pg_dump -h localhost -U postgres -F t -f /tmp/backup/test_db_bk.tar test_db
```

Остановите контейнер с PostgreSQL, но не удаляйте volumes.
```bash
sudo docker start postgres_1
```

Поднимите новый пустой контейнер с PostgreSQL.
```bash
sudo docker run --name postgres_2 -d -e POSTGRES_HOST_AUTH_METHOD=trust -v '/home/bootini/projects/devops-netology/06-db-02-sql/src/data2:/var/lib/postgresql/data' -v '/home/bootini/projects/devops-netology/06-db-02-sql/src/backup:/tmp/backup' postgres:12
``` 

Восстановите БД test_db в новом контейнере.
```bash
sudo docker exec -it postgres_2 psql -U postgres -c "CREATE DATABASE test_db WITH ENCODING='UTF-8';"
sudo docker exec -it postgre2 psql -U postgres -f /tmp/backup/roles.sql
sudo docker exec -it postgres_2 pg_restore -U postgres -Ft -v -d test_db /tmp/backup/test_db_bk.tar
```

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---



