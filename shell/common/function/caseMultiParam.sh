#!/bin/bash

# 测试 case的多值匹配的情况
# 此处使用正则,可以一次匹配多个值
funcMulti1(){
    opt=$1
    case $opt  in
    1|start)
    echo "1 and start ..."
    ;;
    2|stop)
    echo "2 and stop action.."
    ;;
    3|status)
    echo "3 and status...."
    ;;
    *)
    echo "(1 and start) || (2 and stop) || (3 and status)"
    ;;
    esac
}

# 结果
#   [root@name2 opt]# sh case1mul.sh 1
#   1 and start ...
#   [root@name2 opt]# 
#   [root@name2 opt]# sh case1mul.sh start
#   1 and start ...
#   [root@name2 opt]# sh case1mul.sh 2
#   2 and stop action..
#   [root@name2 opt]# sh case1mul.sh stop
#   2 and stop action..
#   
values=("com.ericsson.fcaps.fm.stream.AlarmStandard" "com.ericsson.fcaps.fm.stream.AlarmMasterSlaveCorrelation" "com.ericsson.fcaps.fm.stream.AlarmDerivationCorrelation")
funcMutli2(){
    opt=$1
    case $opt  in
    1|com.*.AlarmStandard)
    echo "1 and AlarmStandard ..."
    ;;
    2|com.*.AlarmMasterSlaveCorrelation)
    echo "2 and AlarmMasterSlaveCorrelation action.."
    ;;
    3|*AlarmDerivationCorrelation)
    echo "3 and AlarmDerivationCorrelation...."
    ;;
    *)
    echo "(1 and start) || (2 and stop) || (3 and status)"
    ;;
    esac
}

funcMutli2 $1

# 结果:
# [root@name2 opt]# sh  case1mul.sh "com.ericsson.fcaps.fm.stream.AlarmStandard"                                          
# 1 and AlarmStandard ...
# [root@name2 opt]# 
# [root@name2 opt]# sh  case1mul.sh "com.ericsson.fcaps.fm.stream.AlarmMasterSlaveCorrelation"                      
# 2 and AlarmMasterSlaveCorrelation action..
# [root@name2 opt]# sh case1mul.sh AlarmDerivationCorrelation
# 3 and AlarmDerivationCorrelation....
