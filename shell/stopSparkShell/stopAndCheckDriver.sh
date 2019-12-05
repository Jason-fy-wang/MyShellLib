#!/bin/bash
BASE=$(cd $(dirname $0); pwd)
## 命令的路径
CMD=/opt/software/spark-2.4.3-bin-hadoop2.7/bin/spark-class
## 具体运行的class
ClassName=org.apache.spark.deploy.Client
## 获取host
# 1.获取host的url路径  2.sed 's#\r##g' 把\r符号去除  3. sed 's#:7077##g' 把7077端口号去除  4.sed 's#,# #g' 把逗号去除
HOSTS=$(cat ${BASE}/config/app.properties | grep sparkUrl | awk -F'=' '{print $2}' | sed 's#\r##g' |sed 's#:7077##g' | sed 's#,# #g')
## 获取 HOSTS 数组的长度
Nhosts=$(echo ${HOSTS} | awk -F=  '{lens=split($1,res," ");print length(res)}')
# 1.从配置文件cat ${BASE}/config/app.properties  | grep 'spark.close' 读取端口号  2.sed 's#\r##g' 去除特殊符号   3.awk -F= '{print $2}' 获取值
PORTS=$(cat ${BASE}/config/app.properties  | grep 'spark.close' | sed 's#\r##g' |awk -F= '{print $2}')

stopApp(){
    if [ ${#PORTS[$@]} -gt 0 ];then     # 遍历端口
        for prt in ${PORTS[@]}
        do
            if [ ${#HOSTS[@]} -gt 0 ];then  # 遍历host，也就是所有的IP和端口进行一次组合
                for host in ${HOSTS[$@]}
                do
                    echo "stopping http://${host}:${prt}/close"
                    curl -X GET  "http://${host}:${prt}/close/"  >/dev/null 2>&1        # 进行具体的删除。并且把标准输出以及错误输出  输出到 /dev/null
                done
                else
                    echo "sparkUrl must be config"
                fi
        done
    else
        echo "spark.close.port must be config"
    fi
}

stopDriver(){
for hst in ${HOSTS}
do
    echo "stopping host: $hst"
    if [ -n $hst ]; then
        DRIVER_ID=$(curl -s http://${hst}:8080 | grep 'value="driver' | grep -oP "driver-[\d-]+")
        if [ -n "${DRIVER_ID[0]}" ];then
            for id in ${DRIVER_ID[@]}
            do
                echo "stopping $id"
                ${CMD} ${ClassName}  kill spark://${hst}:7077 $id >/dev/null 2>&1   # 同样把错误输出以及标准输出  输出到/dev/null
            done
            break 2
        fi
    fi
done
}

checkStatus(){
count=0
for tmp in ${HOSTS}
do
    if [ -n $tmp ]; then
        # 此处就是直接获取到 一个的长度
        drivers=$(echo $(curl -s http://${tmp}:8080 | grep 'value="driver' | grep -oP "driver-[\d-]+") | awk -F=  '{lens=split($1,res," ");print length(res)}')
        if [ ${drivers} -ge 3 ];then
            echo "driver is running......"
            break 2
        else
            # 没有返回有效值，那么计数一次，当计数次数大于总的机器数，那么表示不正常
            let count++
        fi
    fi
    # 如果所有机器返回都 没有，则表示不正常
    if [ $count -ge ${Nhosts} ];then
            echo "driver error .."
    fi
done

}

usage(){

    echo "$0 [ stop | status ]"

}

stop(){
    stopApp
    stopDriver
    echo "driver stopped"
}


main(){
  case $1 in
  stop)
    stop
    ;;
  status)
    checkStatus
    ;;
  *)
    usage
    ;;
  esac
}

main $1