#!/bin/bash
# 遍历数组
# 定义一个数组
arr=(1 2 3 4 5)

# 遍历数组
funcTravleSimple(){
length=${#arr[@]}  # 先获取数组的长度
let leng1=${#arr[@]}-1  # 因为数组下标是从零开始,所以遍历的index=0--arr.lenth-1
leng2=$((${length}-1))  # 同样是获取 遍历的下标
echo "leng1=${leng1}. leng2=${leng2}"
for i in $(seq 0 $leng1)   # 使用下标来遍历数组
do
    echo "index=$i"
    echo ${arr[$i]}
done
}






# 结果
#   [root@name2 opt]# sh arrar.sh 
#   leng1=4. leng2=4
#   index=0
#   1
#   index=1
#   2
#   index=2
#   3
#   index=3
#   4
#   index=4
#   5


# 执行过程
#   [root@name2 opt]# sh -x arrar.sh 
#   + arr=(1 2 3 4 5)
#   + length=5
#   + let leng1=5-1
#   + leng2=4
#   + echo 'leng1=4. leng2=4'
#   leng1=4. leng2=4
#   ++ seq 0 4
#   + for i in '$(seq 0 $leng1)'
#   + echo index=0
#   index=0
#   + echo 1
#   1
#   + for i in '$(seq 0 $leng1)'
#   + echo index=1
#   index=1
#   + echo 2
#   2
#   + for i in '$(seq 0 $leng1)'
#   + echo index=2
#   index=2
#   + echo 3
#   3
#   + for i in '$(seq 0 $leng1)'
#   + echo index=3
#   index=3
#   + echo 4
#   4
#   + for i in '$(seq 0 $leng1)'
#   + echo index=4
#   index=4
#   + echo 5
#   5

# 遍历一些困难些的
FMStandard="com.ericsson.fcaps.fm.stream.AlarmStandard"
FMAMS="com.ericsson.fcaps.fm.stream.AlarmMasterSlaveCorrelation"
FMADC="com.ericsson.fcaps.fm.stream.AlarmDerivationCorrelation"
Apps=($FMStandard $FMAMS $FMADC)

travellonger(){
    opt=$1
    length=${#Apps[@]}  # 先获取数组的长度
    let leng1=${#Apps[@]}-1

    for i in $(seq 0 $leng1)   # 使用下标来遍历数组
    do
        echo "index=$i"
        if [ "${Apps[$i]}" == "$opt" ];then
            echo "${Apps[$i]} ok. index=$i"
            break
        fi
    done
}

travellonger $1

#结果
#   [root@name2 opt]# sh arrar.sh com.ericsson.fcaps.fm.stream.AlarmStandard
#   index=0
#   com.ericsson.fcaps.fm.stream.AlarmStandard ok. index=0
#   [root@name2 opt]# 
#   [root@name2 opt]# 
#   [root@name2 opt]# sh arrar.sh com.ericsson.fcaps.fm.stream.AlarmMasterSlaveCorrelation
#   index=0
#   index=1































