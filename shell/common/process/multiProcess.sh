#!/bin/env bash
NJOBS=8

<< "eof"
初始化fifo文件,用于控制进程的并行度
eof
initFifo(){
    local file=./fifo.$$
    # 打开 管道文件
    mkfifo ${file} && exec 20<>${file}
    if [ "$?" -eq 0 ]; then
        echo "create fifo success"
    else
        echo "create fifo failed"
        exit 1
    fi
    # 向管道中写数据
    for((i=0;i<${NJOBS};i++)){
        echo "init $i" >&20
    }
}

# 从管道中读取数据,然后启动单独的进程进行业务处理
readFifo(){
    while read line 
    do
        echo $line
        {
            # 此处的 sleep用于模拟业务处理
            sleep 20
            echo "back" >&20
        }&
    done <&20
    wait    # 等待子进程结束
    exec 20<&-
}


main(){
    initFifo
    readFifo
}

main




