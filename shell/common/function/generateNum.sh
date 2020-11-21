#!/bin/bash

# 生成随机数序列
for i in {1..5..2}  # 1到5的数  间隔为2
do
    echo $i
done

# 下面这个相当于是多行注释
<< eof
Usage: seq [选项]　　尾数
  or:  seq [选项]　　首数 尾数
  or:  seq [选项]　　首数 增量值　尾数
eof

for i in seq 1 2 5
do 
    echo $i
done

for i in {x,y{i,j}{1,2,3}}
do
    echo $i
done
