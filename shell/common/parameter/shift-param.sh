#!/bin/bash

demo1() {
    until [ $# -eq 0 ]
    do
        echo "第一个参数为 $1"
        shift
    done
}

echo "**********************************************"

demo2() {
    until [ $# -eq 0 ]
    do
        echo $@
        shift
    done
}

demo2 $@


# 结果演示
#   [root@name2 opt]# sh shift1.sh  1 2 3 4 5 6 7 8 9
#   1 2 3 4 5 6 7 8 9
#   2 3 4 5 6 7 8 9
#   3 4 5 6 7 8 9
#   4 5 6 7 8 9
#   5 6 7 8 9
#   6 7 8 9
#   7 8 9
#   8 9
#   9
