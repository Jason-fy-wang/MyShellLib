#!/bin/bash

# 1.某个字段的操作:基本数学运算(加减乘除,取余),逻辑运算(大于 小于 大于等于 小于等于 等于 或 与 非) 正则匹配(~=)  等
<<!
#如果 第5个字段和2取余为0,则进行打印
awk '{if ($5 % 2==0) } print $5}'
!

# if语句
## 打印出能被2整除 且 包含2 的数字
seq 0 10 | awk '{if ($1%2==0 && $1 ~= 2) {print $2}}'


### 对成绩进行分组
seq 0 10 100 | awk '{
    if ($1 >= 90) {print $1,"very good."} 
    else if($1 >= 80) {print $1,"good.."}
    else if ($1 >= 60) {print $1, "work harder."}
    else {print $1,"never give up,you can do it."}
    }'

# awk语言编写脚本
<<!
#!/usr/bin/awk -f
BEGIN{
    for(i=0;i<10;i++){
    print "hello",i
    }
}

!

# 数组

## 打印数组
# 其中遍历时 key是数组的索引, a[key] 才是对应的值
# a[$1]=$4 这就是定义素组了,当然数组也有二维数组
df | awk '{NR !=1;a[$1]=$4} END {for(key in a){print key,"\t",a[key]}}'
<<!
for(i in arr){
    print i,arr[i]
}
!
# for语句
awk 'BEGIN{for(i=0;i<10;i++){print i}}'

# while语句
awk 'BEGIN{i=0; while(i<10) {print i;i++}}'

# 自定义函数
<<!
function 函数名(参数) {指令序列}
!
# 输出招呼
awk 'function mprint(msg){print "hello",msg} BEGIN{mprint("tom")}'

# 对比大小
awk 'function max(x,y){if (x > y) {print "max is", x} else {print "max is",y}} BEGIN{max(10,15)}'

# 内置函数


