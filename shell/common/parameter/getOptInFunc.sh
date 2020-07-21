#!/bin/bash

func_opt(){
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
}

func_opt -m mode1 -f file1 -s sop1 -p 1399

# 输出结果
# [root@name2 opt]# sh optInFunc.sh 
# 1
# MODE=mode1
# FUNC=file1
# SERVER=sop1
# PORT=1399

# 向时间中间添加一个空格
# [root@name2 opt]# echo "2020-07-2117:19:34" | sed -n 's#\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)#\1 #p'
# 2020-07-21 17:19:34

#[root@name2 opt]# echo "2020-07-2117:19:34" | sed -n "s#\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(.*\)#'\1 \2'#p"
# '2020-07-21 17:19:34'