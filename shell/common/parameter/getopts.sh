#!/bin/bash

# 语法: getopts option_string opt 
#  option_string 自定义的选项
#  opt  匹配的选项
# 
# 0: 第一个符号 : 表示静默处理错误
# 1. OPTARG  表示参数对应的值
# 2. m: 后面的 : 表示选项m后需要一个参数
#    m  后面没有: 表示不需要参数,相当于是一个开关,传递此参数,就可以设置 true或false,进行打开或关闭
# 3. opt 表示匹配到的选项值，此处对应为 ":m:f:s:p:" 中的一个
# 4. OPTIND 表示参数的位置,其初始值为1
# 5. 输入参数时,可以无序
# 
# 真实测试时, 以下面的写法为例,某一个参数不传递时,是不报错的
#
:<<1
getopts 处理错误的两种方式:
 getopts can report errors in two ways.If the first character of getopts can report errors in two ways.  
 If the first character of optstring is a colon, silent error reporting is used.  
 In normal operation diagnostic messages are printed when invalid options or missing option arguments are encountered.  If the variable OPTERR is set to 0, no error messages will be displayed,even if the first character of optstring is not a colon.
1

echo ${OPTIND}  # 此处为1
while getopts ":m:f:s:p:" opt
do
    case $opt in
    m)  
       MODE=$OPTARG
    ;;  
    f)  
      FUNC=${OPTARG}
    ;;  
    s)  
      SERVER=${OPTARG}
    ;;  
    p)  
       PORT=$OPTARG
    ;;  
    ?)  
    echo "unknown parameter"
    exit 1;; 
    esac
done
echo "MODE=${MODE}"
echo "FUNC=${FUNC}"
echo "SERVER=${SERVER}"
echo "PORT=${PORT}"

#[root@name2 opt]# sh  getopt.sh -m mode1 -f file1 -s sop1 -p 1399
#MODE=mode1
#FUNC=file1
#SERVER=sop1
#PORT=1399
#

# 不传递某些参数的结果:
# [root@name2 opt]# sh getopt.sh  -f file1 -s sop1 -p 1399
# 1
# 0
# 3
# 5
# MODE=
# FUNC=file1
# SERVER=sop1
# PORT=1399


## sh  getopt.sh -m mode1 -f file1
#   此处: OPTIND 初始值为 1
#         OPTIND=2 表示参数-m; OPTIND=3时,为参数mode1;依次类推, OPTIND=4表示参数 -f,OPTIND=5表示参数file1
#

# 修改,去除p后面的:, 表示p不需要参数
echo ${OPTIND}  # 此处为1
while getopts ":m:f:s:p" opt
do
    case $opt in
    m)  
       MODE=$OPTARG
    ;;  
    f)  
      FUNC=${OPTARG}
    ;;  
    s)  
      SERVER=${OPTARG}
    ;;  
    p)  
       pflag=true    # p参数对应的一个功能开关
    ;;  
    ?)  
    echo "unknown parameter"
    exit 1;; 
    esac
done
echo "MODE=${MODE}"
echo "FUNC=${FUNC}"
echo "SERVER=${SERVER}"
echo "PORT=${PORT}"
:<<10
执行结果:
# sh -x tt.sh -f 2 -s s1 -p p1
+ echo 1
1
+ getopts :m:f:s:p opt
+ case $opt in
+ FUNC=2
+ getopts :m:f:s:p opt
+ case $opt in
+ SERVER=s1
+ getopts :m:f:s:p opt
+ case $opt in
+ PORT=
+ getopts :m:f:s:p opt
+ echo MODE=
MODE=
+ echo FUNC=2
FUNC=2
+ echo SERVER=s1
SERVER=s1
+ echo PORT=
PORT=

由此可以看到,当匹配到参数p时,并没有给OPTARG赋值,即不会获取p后面的参数值,即p不需要参数
10


# 修改 使用 :) 打印没有传递参数的 选项
while getopts ":mf:" opt
do
    case $opt in
    m)  
       MODE=$OPTARG
    ;;  
    f)  
      FUNC=${OPTARG}
    ;;  
    :)
    echo "${OPTARG} requires arg.."
    exit
    ;;
    ?)  
    echo "unknown parameter"
    exit 1;; 
    esac
done
echo "MODE=${MODE}"
echo "FUNC=${FUNC}"

:<<ex
# sh tt.sh -m -f
1
f requires arg..
MODE=
FUNC=
ex