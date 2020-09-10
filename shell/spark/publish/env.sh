#!/bin/bash
BASE=/opt/ericsson/nfvo/fcaps/bin/fm_spark
sparkMaster=`cat ${BASE}/../../config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
driverPort1=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.driver.port1 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
driverPort2=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.driver.port2 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
driverPort3=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.driver.port3 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
blockManagerPort1=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.blockManager.port1 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
blockManagerPort2=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.blockManager.port2 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
blockManagerPort3=`cat ${BASE}/../../config/fm_spark/app.properties | grep spark.blockManager.port3 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
executorMemory1=`cat ${BASE}/../../config/fm_spark/app.properties | grep executor-memory1 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
executorMemory2=`cat ${BASE}/../../config/fm_spark/app.properties | grep executor-memory2 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
executorMemory3=`cat ${BASE}/../../config/fm_spark/app.properties | grep executor-memory3 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
totalExecutorCores1=`cat ${BASE}/../../config/fm_spark/app.properties | grep total-executor-cores1 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
totalExecutorCores2=`cat ${BASE}/../../config/fm_spark/app.properties | grep total-executor-cores2 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
totalExecutorCores3=`cat ${BASE}/../../config/fm_spark/app.properties | grep total-executor-cores3 | awk -F'=' '{print $2}'|sed 's/[\r|\n]//g'`
CMD=/opt/spark-2.4.3/bin/spark-class
ClassName=org.apache.spark.deploy.Client
HOSTS=$(cat ${BASE}/../../config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}' | sed 's#\r##g' |sed 's#:7077##g' | sed 's#,# #g')
Nhosts=$(echo ${HOSTS} | awk -F=  '{lens=split($1,res," ");print length(res)}')

checkMaster(){
HOSTS=$(cat ${BASE}/../../config/fm_spark/app.properties | grep sparkUrl | awk -F'=' '{print $2}' | sed 's#\r##g' |sed 's#:7077##g' | sed 's#,# #g')
Nhosts=$(echo ${HOSTS} | awk -F=  '{lens=split($1,res," ");print length(res)}')
for tmp in ${HOSTS}
do
    if [ -n $tmp ]; then
        result=($(curl -s http://${tmp}:8080 | grep Status: | grep ALIVE ))
        if [ ${#result[@]} -ge 1 ]; then
            echo "the Active Master is: " ${tmp}
            MASTER=${tmp}
            break
        else
            let count++
        fi
        if [ $count -eq ${Nhosts} ];then
            echo "Exception: No Active Master running now."
            exit 1
        fi
    fi
done
}
checkIfSubmit(){
  iv=$1
  ccs=0
  if [ "$len" -gt "0" ]; then
    for ii in $(seq 0 ${len1})
    do
      if [ "$iv" == "${drivers[$ii]}" ];then
        echo 1
        break
      else
        let ccs++
      fi
    done
    if [ "$ccs" -eq "${#drivers[@]}" ]; then
      echo 0
    fi
  else
    echo 0
  fi
}
# 对日志输出的权限做了修改
logSMsg(){
  if [ "$(whoami)" != "fcaps" ]; then
      if [ "$1" == "s" ]; then
      promptMsg="Begin to stop FM Spark $2 applications."
      su - fcaps -c "echo ${promptMsg}"
      su - fcaps -c  "echo \"$(date '+%F %T') ${promptMsg}\" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log"
      elif [ "$1" == "e" ]; then
      promptMsg="FM Spark $2 applications have been stopped."
      su - fcaps -c  echo ${promptMsg}
      su - fcaps -c  "echo \"$(date '+%F %T') ${promptMsg}\" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log"
      else 
      echo ${2}
      su - fcaps -c "echo \"$(date '+%F %T') ${2}\" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log"
      fi
  else
    if [ "$1" == "s" ]; then
    promptMsg="Begin to stop FM Spark $2 applications."
    echo ${promptMsg}
    echo "$(date "+%F %T") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    elif [ "$1" == "e" ]; then
    promptMsg="FM Spark $2 applications have been stopped."
    echo ${promptMsg}
    echo "$(date "+%F %T") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    else 
    echo ${2}
    echo "$(date "+%F %T") ${2}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    fi
  fi
}
# 对日志输出的权限做了修改
logCom(){
  if [ "$(whoami)" != "fcaps" ]; then
    if [ "$1" == "s" ]; then
      promptMsg="Starting FM $2 Application."
      su - fcaps -c  "echo ${promptMsg}"
      su - fcaps -c  "echo \"$(date '+%F %T') ${promptMsg}\" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log"
      elif [ "$1" == "e" ]; then
      promptMsg="Complete $2 Applications startup."
      su - fcaps -c  "echo ${promptMsg}"
      su - fcaps -c  "echo \"$(date '+%F %T') ${promptMsg}\" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log"
      else
        su - fcaps -c  "echo ${2}"
        su - fcaps -c  "echo \"$(date '+%F %T') ${2}\" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log"
      fi
  else
    if [ "$1" == "s" ]; then
    promptMsg="Starting FM $2 Application."
    echo ${promptMsg}
    echo "$(date "+%F %T") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    elif [ "$1" == "e" ]; then
    promptMsg="Complete $2 Applications startup."
    echo ${promptMsg}
    echo "$(date "+%F %T") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    else
      echo ${2}
      echo "$(date "+%F %T") ${2}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    fi
  fi
}


checkMaster
FMStandard="com.ericsson.fcaps.fm.stream.AlarmStandard"
FMAMS="com.ericsson.fcaps.fm.stream.AlarmMasterSlaveCorrelation"
FMADC="com.ericsson.fcaps.fm.stream.AlarmDerivationCorrelation"
Apps=($FMStandard $FMAMS $FMADC)
key1="Running Drivers"
key2="row-fluid"
ids=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>driver-[0-9]{14}-[0-9]{3,}" | awk '{print $1}' | awk -F'>' '{print $2}'))
lenid=${#ids[@]}
let lenids=$lenid-1
drivers=($(curl -s  -X GET http://${MASTER}:8080 | sed -n "/${key1}/,/${key2}/p" | grep -E "<td>com[a-z.]{19,}" | awk '{print $1}' | awk -F'[<>]' '{print $3}' ))
len=${#drivers[@]}
let len1=$len-1

stopId(){
    id=$1
    promptMsg="Stopping $id"
    echo ${promptMsg}
    echo "$(date "+%F %T") ${promptMsg}" >> ${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log
    ${CMD} ${ClassName} kill spark://${MASTER}:7077 $id  >>${BASE}/../../runtime_log/fm_spark/fm_spark_operation.log 2>&1
}

stopDriver(){
    for id in $(seq 0 ${lenids})
    do
        stopId ${ids[$id]}
    done
}

stopAS(){
    dnm=$1
    logSMsg s "$dnm"
    cfg=0
    for i in $(seq 0 $len1)
    do
        if [ "${drivers[$i]}" == "$dnm" ]; then
            echo "ids=${ids[$i]}"
            let cfg++
            stopId ${ids[$i]}
            break
        fi
    done
    if [ "$cfg" -eq "0" ]; then
        logSMsg o "$dnm not running.."
    fi
    logSMsg e "$dnm"
}

run_command(){
com=$@
if [ "$(whoami)" != "fcaps" ]; then
    echo "using the account:fcaps to execute."
    su - fcaps -c "$com"
    echo "Complete the execution."
else
    # 此使用 $() 方式执行传递进来的脚本, 会报找不到文件
    # 可见$() 此方式执行的脚本 是和 PATH环境变量有关
    # 对于一些拼接的命令,可以直接 变量替换后执行
    # $(${com})  替换为 ${com}
    ${com}
fi
}

usage(){
  echo -e  " 1--> AlarmStandard \n 2-->AlarmMasterSlaveCorrelation \n 3-->AlarmDerivationCorrelation\n"
  echo "$0  1 | 2 | 3 | all"
}
