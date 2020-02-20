#!/bin/bash
BASE=$(cd $(dirname $0);pwd)

# 一行一行读取文件内容

usage(){
    echo "usage: $0  filepath"
}

readContent1(){
    if [ $# -ne 1 ];then
        usage
    fi

    cat $1 | while read line
        do
            echo $line      # 把读取的内容打印出来
        done
}


readContent2(){
    if [ $# -ne 1 ];then
        usage
    fi

    while read line
    do
        echo $line          # 打印从文件中读取的内容
    done    < $1
}

readContent3(){
    if [ $# -ne 1 ];then
            usage
    fi

    exec 3<&0
    exec 0<file
    while read line
    do 
            echo $line
            sleep 2
    done
    exec 0<&3
}


readContent3(){
    bak=$IFS        # 保存IFS的值
     if [ $# -ne 1 ];then
            usage
    fi
    # 判断参数是否时文件
    if [ ! -f $1 ]; then
        echo "this $1 is not a file"
    fi

    IFS=$'\n'        # 把分割符修改为换行符; 注意此处设置换行符的方式 有些特殊
    for i in $(cat $1)  # 逐行读取文件内容
    do
        echo $i
    done
}