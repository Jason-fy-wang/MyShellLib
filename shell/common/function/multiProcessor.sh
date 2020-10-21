#!/bin/bash

function sub_process{
    echo "process in pid [$$]"
    sleep 1
}

# 创建一个fifo文件
FIFOFILE=/tmp/$.fifo
mkfifo $FIFOFILE

# 关联fifo文件和fd6
exec 6<>$FIFOFILE  # 将fd6 指向fifo文件
rm $FIFOFILE
# 最大进程数
num=4

# 向fd6中输入num个回车
for ((idx=0; idx < $num;idx++));
do
    echo 
done >&6

# 业务处理,可以使用while
for ((idx=0; idx<20;idx++));
do
# read -u6执行一次,相当于从fd6中读取一行,如果获取不到,则阻塞
# 获取到了一行后,fd6就少了一行,开始子进程处理,子进程放在后台执行
    read -u6 
    {
        sub_process && {
            echo "sub process is finished"
        } || {
            echo "sub process error"
        }
        # 完成后再补充一个回车到fd6中,释放一个锁
        echo >&6
    } &

done

# 关闭fd6
exec 6>&-