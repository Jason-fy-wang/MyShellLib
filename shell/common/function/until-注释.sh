#!/bin/bash
# util
# 1. 第一种注释方式 :<<!  !
:<<!
until 条件
do
    命令序列
done
!

# 2. 第二种注释方式
:'
until 条件
do
    命令序列
done
'
# 3.第三种注释方式
if false; then
until 条件
do
    命令序列
done
fi

# 4. 第四种注释     这里发现使用:<<# 不可以
# :<<任意字符或数字
# 任意字符或数字
:<<1
until 条件
do
    命令序列
done
1
# 5. 第五种注释
((0)) && {
    until 条件
do
    命令序列
done
}

i=0
until [ "$i" -gt 10 ]
do
    echo "$i"
    let i++
done