
import os
import subprocess

with open('.gitmodules', 'r') as fhandle:
    lines=fhandle.readlines()

for line_number,line in enumerate(lines):
    if line.strip().startswith('path = '):
        path = line.strip().split('path = ')[1]
        original_url = lines[line_number+1].strip().split('url = ')[1]
        url = original_url.replace('git@github.com:', 'https://github.com/')
        cmd_list = ['git', 'clone', url, path]
        print(cmd_list)
        subprocess.run(cmd_list)
        



