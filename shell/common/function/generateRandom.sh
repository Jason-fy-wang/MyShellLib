#!/bin/bash
# 生成随机数

# 1. 使用设备生成随机数
useDev(){
    # 生成数字随机数
    # 数字集 可以看 tr的man文档,其中有示例 可用的集合
    tr -cd 0-9 < /dev/urandom | head -c 10
<<!
[root@cn00103147 ~]# tr -cd '0-9' < /dev/urandom |head -c 10
3674176550
!
}

# 2. 使用内置遍历 RANDOM,其返回为[0-32767]
use_inner_param(){
    echo "$RANDOM"
}

# 3. 使用 uuidgen 生成随机数


# 4. openssl生成随机数
use_openssl(){
    openssl rand -hex 1
    openssl rand  -base64 1
    echo abc | openssl passwd -stdin    # 从输入读取数据 生成密码
    echo abd | openssl passwd -stdin -salt hellotom # 自定义salt
<<!
[root@cn00103147 ~]# openssl rand -hex 1
7e
[root@cn00103147 ~]# openssl rand -hex 2
5dd9
[root@cn00103147 ~]# openssl rand -base64 1
KQ==
[root@cn00103147 ~]# echo abc | openssl passwd -stdin 
KuWMtvlJpvPis
[root@cn00103147 ~]# echo abc | openssl passwd -stdin -salt hellotom
heXqmdCTOq0fA
!

<<!
[root@cn00103147 ~]# openssl passwd --help
Usage: passwd [options] [passwords]
where options are
-crypt             standard Unix password algorithm (default)
-1                 MD5-based password algorithm
-apr1              MD5-based password algorithm, Apache variant
-salt string       use provided salt
-in file           read passwords from file
-stdin             read passwords from stdin
-noverify          never verify when reading password from terminal
-quiet             no warnings
-table             format output as table
-reverse           switch table columns
!
}

# 5. 使用hash值生成随机值
use_hash(){
    echo abc | md5sum
    echo ab | sha256sum
}
