#!/bin/bash
# select使用

# select 自己生成了一个选项列表
select i in tom ant koco
do
    echo "$i"
done


<<!
输出
[root@localhost sh]# sh tt.sh 
1) tom
2) ant
3) koco
#? 3
koco
!