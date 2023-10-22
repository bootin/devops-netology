# Домашнее задание к занятию 4. «PostgreSQL»

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
```bash
sudo docker run --name postgres_1 -d -e POSTGRES_HOST_AUTH_METHOD=trust -v '/home/bootini/projects/devops-netology/06-db-04-postgresql/src/data:/var/lib/postgresql/data' -v '/home/bootini/projects/devops-netology/06-db-04-postgresql/src/backup:/tmp/backup' postgres:13
```

Подключитесь к БД PostgreSQL, используя `psql`.
```bash
sudo docker exec -it postgres_1 psql -U postgres
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД,
```sql
\l[+] [PATTERN] list databases
```
- подключения к БД,
```sql
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
connect to new database (currently "postgres")
```
- вывода списка таблиц,
```sql
\d[S+] list tables, views, and sequences 
\dt[S+] [PATTERN] list tables
```
- вывода описания содержимого таблиц,
```sql
\dS+ или \dtS+
```
- выхода из psql.
```sql
\q
```

## Задача 2

Используя `psql`, создайте БД `test_database`.
```sql
CREATE DATABASE test_database;
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```sql
test_database=# \c test_database;
test_database=# \i /tmp/backup/test_dump.sql
```
Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```sql
test_database=# \c test_database
test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления, и полученный результат.
```sql
test_database=# SELECT tablename, attname, max(avg_width) FROM pg_stats WHERE tablename='orders' ORDER BY avg_width DESC LIMIT 1;
 tablename | attname | avg_width
-----------+---------+-----------
 orders    | title   |        16
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили
провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.
```sql
ALTER TABLE public.orders RENAME TO orders_old;

CREATE TABLE public.orders (
id integer NOT NULL,
title character varying(80) NOT NULL,
price integer DEFAULT 0
)
PARTITION BY RANGE (price);

CREATE TABLE public.orders_1 PARTITION OF public.orders FOR VALUES FROM ('0') TO ('499');
CREATE TABLE public.orders_1 PARTITION OF public.orders FOR VALUES FROM ('499') TO ('2147483647');

INSERT INTO public.orders SELECT * FROM public.orders_old;
DROP TABLE public.orders_old;
```

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?
```txt
Можно, как видно из предыдущей части решения.
```

## Задача 4

Используя утилиту `pg_dump`, создайте бекап БД `test_database`.
```bash
sudo docker exec -it postgres_1 pg_dump -Cc -f /tmp/backup/test_database_bk.sql -F p -U postgres
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
```sql
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_title_unique UNIQUE (title, price);

ALTER TABLE ONLY public.orders_1
    ADD CONSTRAINT orders_1_title_price_key UNIQUE (title, price);

ALTER TABLE ONLY public.orders_2
    ADD CONSTRAINT orders_2_title_price_key UNIQUE (title, price);

ALTER INDEX public.orders_title_unique ATTACH PARTITION public.orders_1_title_price_key;

ALTER INDEX public.orders_title_unique ATTACH PARTITION public.orders_2_title_price_key;
```
Это добавилось в бекап после применения `ALTER TABLE public.orders ADD CONSTRAINT orders_title_unique UNIQUE (title, price);`. Без указания `price` добавить уникальности столбцу title невозможно - ошибка
```err
ERROR:  unique constraint on partitioned table must include all partitioning columns
DETAIL:  UNIQUE constraint on table "orders" lacks column "price" which is part of the partition key.
```

