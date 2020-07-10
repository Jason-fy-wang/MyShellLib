#!/bin/bash

func(){
    echo "please input your name"
    read name
    # return 可以终止方法继续执行
    if [ "$name" != "wang" ]; then
        return
    fi
    echo "your name is : $name"
}


while true
do
  func 
done

# 结果:
# [root@name2 opt]# sh termiateFunc.sh 
# please input your name
# wang
# your name is : wang
# please input your name
# 123
# please input your name
# 123
# please input your name
# 345
# please input your name
# ^C
