#!/bin/bash
BASE=$(cd $(dirname $0);pwd)
USER=root
## 此脚本把指定的文件或目录赋值到对应机器的  BASE 目录(也就是当前脚本对应的路径)
main(){
    
    if [ "$#" -lt 2 ];then
        echo "usage: $0 file|dir  host1 host2...hostN"
        exit 0
    fi
    # 文件
    file=$1
    params=($*)
    # 获取所有的主机
    hosts=${params[@]:1:${#params[@]}}
    if [ -f $file ];then        # 拷贝文件
        for hh in ${hosts[@]}
        do  
            echo "copy $file to $hh"
            scp $file ${USER}@${hh}:$BASE/
        done
    elif [ -d $file ];then      # 拷贝目录
        for hh in ${hosts[@]}
        do  
            echo "copying dir to $hh"
            scp -r  $file ${USER}@${hh}:$BASE/
        done

    fi  
}

main $*