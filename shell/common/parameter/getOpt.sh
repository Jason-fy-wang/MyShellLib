#!/usr/bin/env bash
:<<arg
参数使用说明:
-o: 指定短参数,这里指定的是 a b c
--long 指定的是长参数,这里指定的是 along  blong  clong
其中:
a  表示没有参数值,相当于只是一个开关参数
b: 表示需要有参数值
c::  可选参数值
 具体使用可以看下面的example
arg

echo "all arg: $@"
ARGS=$(getopt -o ab:c:: --long along,blong:,clong:: -- "$@")

if [ $? != 0 ]; then
    echo "Terminating...."
    exit
fi

eval set -- "${ARGS}"

while true
do
    case "$1" in
    -a|--along)
        aflag=true  # 参数a对应的开关
        echo "Option a"
        shift
    ;;
    -b|--blong)
        echo "Option b, argumnet $2"
        shift 2
    ;;
    -c|--clong)
    case "$2" in
        "")
            echo "Option c, no argument"
            shift 2
            ;;
        *)
            echo "Option c, argument $2"
            shift 2
        ;;
    ;;
    --)
    shift
    break
    ;;
    *)
    echo "internal error!"
    exit 
    ;;
    esac
done


# 处理剩余的参数
for arg in $@
do
    echo "processing $arg"
done


:<<89

# sh  ss.sh -a "aval" --blong "1234 56" opt1 -c123
all arg: -a aval --blong 1234 56 opt1 -c123
Option a
Option b, argumnet 1234 56
Option c, argument 123
processing aval
processing opt1

# sh  ss.sh -a "aval" --blong "1234 56" opt1 -c 123
all arg: -a aval --blong 1234 56 opt1 -c 123
Option a
Option b, argumnet 1234 56
Option c, no argument
processing aval
processing opt1
processing 123

结果对比看到: 可选参数-c 必须紧贴参数值才可以
--------------------------------------------------------------------------------------------------------------
# sh ss.sh -a -b "1234 56" --clong=clong
all arg: -a -b 1234 56 --clong=clong
Option a
Option b, argumnet 1234 56
Option c, argument clong
--------------------------------------------------------------------------------------------------------------
sh ss.sh -a --blong "1234 56" --clong=clong
all arg: -a --blong 1234 56 --clong=clong
Option a
Option b, argumnet 1234 56
Option c, argument clong
--------------------------------------------------------------------------------------------------------------
sh ss.sh -a --blong "1234 56" opt1 opt3 --clong=clong
all arg: -a --blong 1234 56 opt1 opt3 --clong=clong
Option a
Option b, argumnet 1234 56
Option c, argument clong
processing opt1
processing opt3
--------------------------------------------------------------------------------------------------------------
sh  ss.sh -a "aval" --blong "1234 56" opt1 opt3 --clong=clong
all arg: -a aval --blong 1234 56 opt1 opt3 --clong=clong
Option a
Option b, argumnet 1234 56
Option c, argument clong
processing aval
processing opt1
processing opt3
--------------------------------------------------------------------------------------------------------------
# sh -x  ss.sh -a "aval" --blong "1234 56" opt1 opt3 --clong=clong
+ echo 'all arg: -a' aval --blong '1234 56' opt1 opt3 --clong=clong
all arg: -a aval --blong 1234 56 opt1 opt3 --clong=clong
++ getopt -o ab:c:: --long along,blong:,clong:: -- -a aval --blong '1234 56' opt1 opt3 --clong=clong
+ ARGS=' -a --blong '\''1234 56'\'' --clong '\''clong'\'' -- '\''aval'\'' '\''opt1'\'' '\''opt3'\'''
+ '[' 0 '!=' 0 ']'
+ eval set -- ' -a --blong '\''1234 56'\'' --clong '\''clong'\'' -- '\''aval'\'' '\''opt1'\'' '\''opt3'\'''
++ set -- -a --blong '1234 56' --clong clong -- aval opt1 opt3
+ true
+ case "$1" in
+ echo 'Option a'
Option a
+ shift
+ true
+ case "$1" in
+ echo 'Option b, argumnet 1234 56'
Option b, argumnet 1234 56
+ shift 2
+ true
+ case "$1" in
+ case "$2" in
+ echo 'Option c, argument clong'
Option c, argument clong
+ shift 2
+ true
+ case "$1" in
+ shift
+ break
+ for arg in '$@'
+ echo 'processing aval'
processing aval
+ for arg in '$@'
+ echo 'processing opt1'
processing opt1
+ for arg in '$@'
+ echo 'processing opt3'
processing opt3
--------------------------------------------------------------------------------------------------------------
# sh -x  ss.sh -a --blong "1234 56" opt1 opt3 --clong=clong
+ echo 'all arg: -a' --blong '1234 56' opt1 opt3 --clong=clong
all arg: -a --blong 1234 56 opt1 opt3 --clong=clong
++ getopt -o ab:c:: --long along,blong:,clong:: -- -a --blong '1234 56' opt1 opt3 --clong=clong
+ ARGS=' -a --blong '\''1234 56'\'' --clong '\''clong'\'' -- '\''opt1'\'' '\''opt3'\'''
+ '[' 0 '!=' 0 ']'
+ eval set -- ' -a --blong '\''1234 56'\'' --clong '\''clong'\'' -- '\''opt1'\'' '\''opt3'\'''
++ set -- -a --blong '1234 56' --clong clong -- opt1 opt3
+ true
+ case "$1" in
+ echo 'Option a'
Option a
+ shift
+ true
+ case "$1" in
+ echo 'Option b, argumnet 1234 56'
Option b, argumnet 1234 56
+ shift 2
+ true
+ case "$1" in
+ case "$2" in
+ echo 'Option c, argument clong'
Option c, argument clong
+ shift 2
+ true
+ case "$1" in
+ shift
+ break
+ for arg in '$@'
+ echo 'processing opt1'
processing opt1
+ for arg in '$@'
+ echo 'processing opt3'
processing opt3
89