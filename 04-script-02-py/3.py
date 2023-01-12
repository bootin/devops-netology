#!/usr/bin/env python3

import os
import sys

dir_param = str(sys.argv[1])
if ( dir_param[-1] == '/' ):
    git_home = dir_param
else:
    git_home = dir_param + '/'
bash_command = ["cd {}".format(git_home), "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
if ( result_os.find('On branch') != -1 ):
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', git_home)
            print(prepare_result)
