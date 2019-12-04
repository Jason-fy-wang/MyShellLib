#!/bin/bash


BASE=$(cd $(dirname $0);pwd)
# 业务包名字
JAR_NAME=fcaps-controller.jar
# 业务jar包的全路径
JAR_PATH=${BASE}/../boot/${JAR_NAME}
# 设置依赖包的目录
LIB=${BASE}/../lib
HOST=$(cat /etc/hostname)
# 配置文件全路径
CONFIG_FILE=${BASE}/../config/nfvo.properties
CONFIG=${BASE}/../config/
# 日志
LOG=${BASE}/../logs/runtime_${HOST}.log
# print gc log
PrintGCLog=" -XX:+PrintGCDetails -XX:+PrintGC -XX:+PrintGCDateStamps -Xloggc:${BASE}/../logs/gc.log"  #PrintGCTimeStamps
# dump oom
DumpFile="-XX:+HeapDumpOnOutOfMemoryError  -XX:HeapDumpPath=${BASE}/../logs/dump.hprof"
# 当发生OOM时，运行一些命令
OOMFix="-XX:OnOutOfMemoryError=sh ${BASE}/start.sh restart"
# 虚拟机参数
JAVA_ARG="-Xmx512m -Xms512m -server  -Dloader.path=.,${LIB},${CONFIG}  -Dconfig.path=${CONFIG_FILE} ${DumpFile} #{PrintGCLog}"


function usage(){
        echo
        echo "usage: $0 [start | stop | restart | status]"
        echo
}

function start(){
                echo
        echo "starting app..."
                echo
        if [ -e ${LOG} ];then
            mv ${LOG} ${BASE}/../logs/runtime_${HOST}_$(date +"%F_%T").log
        fi
        nohup java -XX:OnOutOfMemoryError="sh ${BASE}/start.sh restart" ${JAVA_ARG} -jar ${JAR_PATH} -Dspring.profile.active=pro > ${LOG} 2>&1&
}


function stop(){
        PID=$(ps -ef | grep -v grep | grep "$JAR_NAME"  | awk '{print $2}')
        if [ ${#PID[@]} -gt 0 ];then
            for pid in ${PID[@]}
             do
                echo
                echo "stopping  app $JAR_NAME $pid.."
                echo
                kill -9 $pid
             done
         else
                echo
                echo "$JAR_NAME already stopped ... "
                echo
         fi
}

function status(){
         PID=$(ps -ef | grep -v grep | grep "$JAR_NAME"  | awk '{print $2}')
         local count=0
         for pid in ${PID[@]}
           do
             if [ ${pid} -gt 0 ]; then
                let "count+=1"
             fi
           done
         if [ ${count} -eq 1 ];then
                echo
                echo "$JAR_NAME is running ..."
                echo
         elif [ ${count} -eq 0 ];then
                echo
                echo "$JAR_NAME stopped ... "
                echo
         else
                echo
                echo "multi $JAR_NAME running ... "
                echo
         fi
}

function restart(){
        stop
        sleep 1
        start
}

function main(){
        if [ $# != 1 ]; then
                usage
                exit 1
        fi
        case $1 in
        'start')
                start
                ;;
        'stop')
                stop
                ;;
        'restart')
                restart
                ;;
        'status')
                status
                ;;
        *)
                usage
                ;;
        esac
}
main $1
