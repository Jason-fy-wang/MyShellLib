### ansible 基本命令

# 显示版本
ansible --version

# 测试某台主机的连通性
ansible 192.168.30.15 -m ping

# display all available plugin
ansible-doc -l

# display help on specific plugin
ansible-doc ping

# test host group
ansible group1 -m ping

# 列出某个组所有host
ansible all --list-hosts

# exec shell cmd in client
ansible group1 -m shell -a 'echo hello ansible!'
-a: module args

# 并发执行任务 (Concurrent execution of tasks)
ansible group1 -m shell -a 'uname -r' -f 5  -o
-f  并发度为5
-o  output one line

# 异步执行任务(execution task asynchronously)
[root@name2 ansible]# ansible group1 -B 120 -P 0 -m shell -a 'sleep 5; hostname' -o -f 5
-B 后台执行的超时时间
-P 查询结果的间隔时间

192.168.30.15 | CHANGED => {"ansible_facts": {"discovered_interpreter_python": "/usr/bin/python"}, "ansible_job_id": "826978609093.56426", "changed": true, "finished": 0, "results_file": "/root/.ansible_async/826978609093.56426", "started": 1}
192.168.30.16 | CHANGED => {"ansible_facts": {"discovered_interpreter_python": "/usr/bin/python"}, "ansible_job_id": "787058944503.8310", "changed": true, "finished": 0, "results_file": "/root/.ansible_async/787058944503.8310", "started": 1}

#### 查询任务结果(query task result)
[root@name2 ansible]# ansible group1 -B 120 -P 2 -m shell -a 'sleep 5; hostname' -f 5
192.168.30.15 | CHANGED => {
    "ansible_job_id": "61659151028.57806", 
    "changed": true, 
    "cmd": "sleep 5; hostname", 
    "delta": "0:00:05.008547", 
    "end": "2021-06-14 22:42:27.114819", 
    "finished": 1, 
    "rc": 0, 
    "start": "2021-06-14 22:42:22.106272", 
    "stderr": "", 
    "stderr_lines": [], 
    "stdout": "name2", 
    "stdout_lines": [
        "name2"
    ]
}
192.168.30.16 | CHANGED => {
    "ansible_job_id": "110305722530.9244", 
    "changed": true, 
    "cmd": "sleep 5; hostname", 
    "delta": "0:00:05.007409", 
    "end": "2021-06-14 22:42:27.235884", 
    "finished": 1, 
    "rc": 0, 
    "start": "2021-06-14 22:42:22.228475", 
    "stderr": "", 
    "stderr_lines": [], 
    "stdout": "name3", 
    "stdout_lines": [
        "name3"
    ]
}


# ansible-playbook 
### 语法检查
[root@name2 ansible]# ansible-playbook --syntax-check first.yaml 
playbook: first.yaml

### 列出 yaml中的主机
[root@name2 ansible]# ansible-playbook --list-hosts first.yaml 
playbook: first.yaml

  play #1 (192.168.30.15): 192.168.30.15        TAGS: []
    pattern: [u'192.168.30.15']
    hosts (1):
      192.168.30.15

### 列出yaml中的任务列表
[root@name2 ansible]# ansible-playbook --list-tasks first.yaml 
playbook: first.yaml

  play #1 (192.168.30.15): 192.168.30.15        TAGS: []
    tasks:
      shell cmd TAGS: []
      command module    TAGS: []
