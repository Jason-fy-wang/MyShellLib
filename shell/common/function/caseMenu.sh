#!/bin/bash

# ;; 结束, ;& 继续执行, ;;& 继续匹配

read -p "please input [a-z]" num

case $num in 
a)
    echo "first a"
    ;&         # 继续匹配
b)
    echo "input b"
    ;;
c)
    echo "input c"
    ;;
a)
    echo "second a"
    ;;&      # 继续执行

d)
    echo "input d"
    ;;
*)
    echo "input inalid"
    ;;
esac
