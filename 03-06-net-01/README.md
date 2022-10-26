# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?

    ```bash
    *********@DESKTOP-SOME:~$ telnet stackoverflow.com 80
    Trying 151.101.129.69...
    Connected to stackoverflow.com.
    Escape character is '^]'.
    GET /questions HTTP/1.0
    HOST: stackoverflow.com

    HTTP/1.1 403 Forbidden
    ...
    ```
    В доступе отказано
    
    ```bash
    *********@DESKTOP-SOME:~$ telnet miranda-media.ru 80
    Trying 185.64.46.66...
    Connected to miranda-media.ru.
    Escape character is '^]'.
    GET /questions HTTP/1.0
    HOST:  miranda-media.ru

    HTTP/1.1 301 Moved Permanently
    ...
    ```
    Перенаправление на актуальный адрес

2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.

    ```txt
    Получен код ответа 301. Дольше всего отбрабатывался поиск DNS и его резолв.
    ```

3. Какой IP адрес у вас в интернете?

    ```bash
    *********@DESKTOP-SOME:~$ curl 2ip.ru
    xxx.xxx.221.103
    ```

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`

    ```bash
    root@DESKTOP-SOME:/home/*********# nslookup ya.ru
    Server:         xxx.xxx.112.1
    Address:        xxx.xxx.112.1#53

    Non-authoritative answer:
    Name:   ya.ru
    Address: 87.250.250.242
    Name:   ya.ru
    Address: 2a02:6b8::2:242
    
    root@DESKTOP-SOME:/home/*********# whois 87.250.250.242
    ...
    origin:         AS13238
    mnt-by:         YANDEX-MNT
    ```

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`

    ```bash
    root@DESKTOP-SOME:/home/*********# traceroute -An 8.8.8.8
    traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
     1  xxx.xxx.112.1 [*]  0.841 ms  0.789 ms  0.704 ms
     2  xxx.xxx.88.1 [*]  3.983 ms  3.941 ms  3.925 ms
     3  * * *
     4  xxx.xxx.131.76 [ASxxxxx]  4.450 ms  4.402 ms  5.147 ms
     5  185.214.245.46 [AS48084]  20.889 ms  21.615 ms  18.370 ms
     6  142.250.172.68 [AS15169]  38.396 ms  37.138 ms  37.060 ms
     7  * * *
     8  108.170.250.129 [AS15169]  37.697 ms  34.063 ms 108.170.250.33 [AS15169]  37.910 ms
     9  108.170.250.83 [AS15169]  33.339 ms 108.170.250.146 [AS15169]  34.583 ms  34.433 ms
    10  209.85.249.158 [AS15169]  47.701 ms 142.251.237.154 [AS15169]  50.060 ms 72.14.234.54 [AS15169]  51.401 ms
    11  72.14.235.69 [AS15169]  49.893 ms 216.239.48.224 [AS15169]  56.815 ms 142.251.237.142 [AS15169]  52.065 ms
    12  216.239.49.3 [AS15169]  50.714 ms 209.85.254.135 [AS15169]  57.845 ms 142.250.209.161 [AS15169]  53.768 ms
    13  * * *
    14  * * *
    15  * * *
    16  * * *
    17  * * *
    18  * * *
    19  * * *
    20  8.8.8.8 [AS15169]  51.631 ms * *
    ```

6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?

    ```bash
						   My traceroute  [v0.93]
    DESKTOP-SOME (172.31.124.132)                                                               2022-10-26T21:54:19+0300
    Keys:  Help   Display mode   Restart statistics   Order of fields   quit
										   Packets               Pings
     Host                                                                        Loss%   Snt   Last   Avg  Best  Wrst StDev
     1. AS???    xxx.xxx.112.1                                                     0.0%    20    0.5   0.4   0.2   0.8   0.2
     2. AS???    xxx.xxx.88.1                                                     0.0%    20    4.3   3.3   2.2   6.4   1.2
     3. (waiting for reply)
     4. ASxxxxx   xxx.xxx.131.76                                                   0.0%    20    5.9   9.7   3.8  45.9   9.7
     5. AS48084  185.214.245.46                                                   0.0%    20   21.0  25.0  20.6  63.0  10.3
     6. AS15169  142.250.172.68                                                   0.0%    20   37.3  41.0  37.0  93.4  12.4
     7. AS15169  108.170.250.33                                                   0.0%    20   37.4  38.2  36.4  45.3   2.1
     8. AS15169  108.170.250.34                                                   0.0%    20   37.5  38.3  36.0  60.9   5.5
     9. AS15169  142.251.238.82                                                   0.0%    20   54.1  54.8  52.8  62.9   2.4
    10. AS15169  142.251.238.68                                                   0.0%    20   54.4  55.2  52.3  88.2   7.9
    11. AS15169  142.250.232.179                                                  0.0%    20   53.7  51.2  49.9  54.5   1.3
    12. (waiting for reply)
    13. (waiting for reply)
    14. (waiting for reply)
    15. (waiting for reply)
    16. (waiting for reply)
    17. (waiting for reply)
    18. (waiting for reply)
    19. (waiting for reply)
    20. (waiting for reply)
    21. AS15169  8.8.8.8                                                          0.0%    19   53.9  53.9  52.7  56.3   0.9

    ```
    
    Задержки больше всего на участке внутри AS15169

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`

    ```bash
    root@DESKTOP-SOME:/home/*********# dig +trace dns.google
    ...
    dns.google.             10800   IN      NS      ns4.zdns.google.
    dns.google.             10800   IN      NS      ns1.zdns.google.
    dns.google.             10800   IN      NS      ns2.zdns.google.
    dns.google.             10800   IN      NS      ns3.zdns.google.
    ```
    NS сервера, отвечающие за зону `dns.google.`.
    
    ```bash
    root@DESKTOP-SOME:/home/*********# dig +trace dns.google
    ...
    dns.google.             900     IN      A       8.8.8.8
    dns.google.             900     IN      A       8.8.4.4
    ```
    A-записи

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`

    ```bash
    root@DESKTOP-SOME:/home/*********#  dig -x 8.8.8.8
    ...
    ;; ANSWER SECTION:
    8.8.8.8.in-addr.arpa.   0       IN      PTR     dns.google.
    ```
    ```bash
    root@DESKTOP-SOME:/home/*********#  dig -x 8.8.4.4
    ...
    ;; ANSWER SECTION:
    4.4.8.8.in-addr.arpa.   0       IN      PTR     dns.google.
    ```

В качестве ответов на вопросы можно приложите лог выполнения команд в консоли или скриншот полученных результатов.

---