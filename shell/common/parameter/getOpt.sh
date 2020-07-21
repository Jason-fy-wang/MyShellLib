#!/bin/bash

# 语法: getopts option_string opt 
#  option_string 自定义的选项
#  opt  匹配的选项
# 
#  
# 1. OPTARG  表示参数对应的值
# 2. :m 表示m参数不是必传递;  m 表示:此选项不传递参数时 会报错
#   如: m:f:  此表示m不传递参数不会报错, f选项不传递参数会报错
#   m,f:    表示m,f 选项不传递参数不会报错
# 3. opt 表示匹配到的选项值，此处对应为 ":m:f:s:p:" 中的一个
# 4. OPTIND 表示参数的位置,其初始值为1
# 5. 输入参数时,可以无序
# 
# 真实测试时, 以下面的写法为例,某一个参数不传递时,是不报错的
#

echo ${OPTIND}  # 此处为1
while getopts ":m:f:s:p:" opt
do
    case $opt in
    m)  
       MODE=$OPTARG
    ;;  
    f)  
      FUNC=${OPTARG}
    ;;  
    s)  
      SERVER=${OPTARG}
    ;;  
    p)  
       PORT=$OPTARG
    ;;  
    ?)  
    echo "unknown parameter"
    exit 1;; 
    esac
done
echo "MODE=${MODE}"
echo "FUNC=${FUNC}"
echo "SERVER=${SERVER}"
echo "PORT=${PORT}"

#[root@name2 opt]# sh  getopt.sh -m mode1 -f file1 -s sop1 -p 1399
#MODE=mode1
#FUNC=file1
#SERVER=sop1
#PORT=1399
#

# 不传递某些参数的结果:
# [root@name2 opt]# sh getopt.sh  -f file1 -s sop1 -p 1399
# 1
# 0
# 3
# 5
# MODE=
# FUNC=file1
# SERVER=sop1
# PORT=1399


## sh  getopt.sh -m mode1 -f file1
#   此处: OPTIND 初始值为 1
#         OPTIND=2 表示参数-m; OPTIND=3时,为参数mode1;依次类推, OPTIND=4表示参数 -f,OPTIND=5表示参数file1
#         