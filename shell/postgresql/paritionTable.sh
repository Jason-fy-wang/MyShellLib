#!/bin/bash

:<<!
1. 创建下一个月的表
2. 清除两年前的对应的表
!
curYear=$(date +"%Y")
curMonth=$(date +"%m")
let todrop="curYear-2"
dopmonth=${curMonth}
let nxtMonth="curMonth+1"

if [ "${curMonth}" -eq "12" ];then
    curMonth=01
    let curYear="curYear+1"
    let nxtMonth="curMonth+1"
elif [ "${nxtMonth}" -gt "12" ]; then
    nxtMonth=01
fi
# 给单字符的 月份添加0
if [[ "${curMonth}" =~ ^[1-9]{1} ]]; then
    curMonth=0${curMonth}
fi

if [[ "${nxtMonth}" =~ ^[1-9]{1} ]]; then
    nxtMonth=0${nxtMonth}
fi
# 输出要删除的 以及 要创建的表名 以及 子表月份范围
echo "drop table measure_y${todrop}_${dopmonth}"
echo "new table measure_y${curYear}_${curMonth},from ${curMonth} to ${nxtMonth})"


## 第二种 依赖于 数据库计算时间



