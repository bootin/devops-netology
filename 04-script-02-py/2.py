#!/usr/bin/env python3

import os

git_home = "/home/user/pycharm/git/devops-netology/"
bash_command = ["cd {}".format(git_home), "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', git_home)
        print(prepare_result)
