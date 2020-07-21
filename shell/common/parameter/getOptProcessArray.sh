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
# -m mode1 -f file1 -s sop1 -p 1399
read -p "Please input value:" -a arr
func_opt ${arr[@]}

# 结果:
# [root@name2 opt]# sh optinArr.sh 
# Please input value:-m mode1 -f file1 -s sop1 -p 1399
# 1
# MODE=mode1
# FUNC=file1
# SERVER=sop1
# PORT=1399
# 

# [root@name2 opt]# sh optinArr.sh 
# Please input value:-m mode1 -f file1 -s sop1 -p '2020-01-01 00:00:00'
# 

# MODE=mode1
# FUNC=file1
# SERVER=sop1
# PORT=2020-01-01 00:00:00
