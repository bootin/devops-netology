#!/usr/bin/env python3

import socket
import time

interval = 60
hosts = {'drive.google.com':'1.251.36.142', 'mail.google.com':'142.25.36.133', 'google.com':'142.251.36.142'}
for host in hosts:
    ip = socket.gethostbyname(host)
    if ip != hosts[host]:
        print("[ERROR] <{}> IP mismatch: <{}> <{}>".format(host, hosts[host], ip))
        hosts[host] = ip
time.sleep(interval)