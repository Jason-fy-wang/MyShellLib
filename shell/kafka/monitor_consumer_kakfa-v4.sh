#!/bin/bash
# monitor kafak consume situation
KCMD=/opt/kafka-2.11/bin/kafka-consumer-groups.sh
RCMD=/opt/redis-5.0.0/6379/redis-cli
LOGPath=/opt/ericsson/nfvo/fcaps/runtime_log/tools


log(){
    echo "$(date +'%F %T'): ${group_id}  $@" >> ${file}
}

acquireKey(){
    flag=0
    for ar in ${raddr}
    do  
        s=$(echo ${ar} | cut -d: -f1)
        p=$(echo ${ar} | cut -d: -f2)
        res=$(${RCMD} -h $s -p $p -c setnx ${mutex_lock} 123 2>&1)
        log "acquire res=$res"
        echo $res | grep "$s" >/dev/null 2>&1
        if [ "$?" -gt "0" ]; then
            echo $res | grep "1" >/dev/null 2>&1
            if [ "$?" -eq "0" ]; then
                flag=1
                break
            fi
        fi
    done
    if [ "${flag}" -eq "1" ]; then
        ${RCMD} -h $s -p $p -c expire ${mutex_lock} 40   >/dev/null 2>&1
    else
        log "Another script is running, begin to exit."
        exit 1
    fi
}

releaseKey(){
    for ar in ${raddr}
    do  
        s=$(echo ${ar} | cut -d: -f1)
        p=$(echo ${ar} | cut -d: -f2)
        res=$(${RCMD} -h $s -p $p -c del ${mutex_lock} 2>&1)
        log "del res=$res"
        echo $res | grep "$s" >/dev/null 2>&1
        if [ "$?" -gt "0" ]; then
            echo $res | grep -E "[1-9]{1,}" >/dev/null 2>&1
            if [ "$?" -eq "0" ]; then
                break
            fi
        fi
    done
}

updateheartbeat(){
    heartKey="${rkey}"
    val=$(date +"%y%m%d%H%M%S")
    for ar in ${raddr}
    do  
        s=$(echo ${ar} | cut -d: -f1)
        p=$(echo ${ar} | cut -d: -f2)
        res=$(${RCMD} -h $s -p $p -c set  ${heartKey} ${val} EX 120 2>&1)
        log "update heartbeat res=$res"
        echo $res | grep "$s" >/dev/null 2>&1
        if [ "$?" -gt "0" ]; then
            echo $res | grep -E "OK|[1-9]{1,}" >/dev/null 2>&1
            if [ "$?" -eq "0" ]; then
                break
            fi
        fi
    done
}

saveLastConsumerVal(){
    valKey="${group_id}:monitor"
    for ar in ${raddr}
    do  
        s=$(echo ${ar} | cut -d: -f1)
        p=$(echo ${ar} | cut -d: -f2)
        res=$(${RCMD} -h $s -p $p -c hset  ${valKey} ${1} "${2}" EX 604800 2>&1)
        log "save res=$res"
        echo $res | grep "$s" >/dev/null 2>&1
        if [ "$?" -gt "0" ]; then
            echo $res | grep -E "OK|[0-9]{1,}" >/dev/null 2>&1
            if [ "$?" -eq "0" ]; then
                break
            fi
        fi
    done
}

getLastVal(){
    valKey="${group_id}:monitor"
    for ar in ${raddr}
    do  
        s=$(echo ${ar} | cut -d: -f1)
        p=$(echo ${ar} | cut -d: -f2)
        res=$(${RCMD} -h $s -p $p -c hget  ${valKey} ${1} 2>&1)
        log "get res=$res"
        echo $res | grep "$s" >/dev/null 2>&1
        if [ "$?" -gt "0" ]; then
            gval=${res}
            break
        fi
    done
}

existsKey(){
    valKey="${group_id}:monitor"
    exists=0
    for ar in ${raddr}
    do  
        s=$(echo ${ar} | cut -d: -f1)
        p=$(echo ${ar} | cut -d: -f2)
        res=$(${RCMD} -h $s -p $p -c exists  ${valKey} 2>&1)
        log "check exists res=$res"
        echo $res | grep "$s" >/dev/null 2>&1
        if [ "$?" -gt "0" ]; then
            echo $res | grep -E "[1-9]{1,}" >/dev/null 2>&1
            if [ "$?" -eq "0" ]; then
                exists=1
                break
            fi
            echo $res | grep "0" >/dev/null 2>&1
            if [ "$?" -eq "0" ]; then
                exists=0
                break
            fi
        fi
    done
}

healthCheck(){

    if [ ! -d "${LOGPath}" ]; then
        echo "Please create dir first: ${LOGPath}"
        exit
    fi

    if [ -z "${group_id}" ]; then
        echo  "group_id should give."
        exit
    fi
    nn=monitor_consumer_kafka_${group_id}
    file=${LOGPath}/${nn}-$(date +'%Y%m%d').log
    u=$(whoami)

    if [ -z "$u" -o  "$u" != "fcaps" ]; then
        log "please run with user fcaps."
        exit
    fi

    if [ -z "${mutex_lock}" ]; then
        log "redis mutex key should be given."
        exit
    fi

    if [ -z "${rstoreFile}" ]; then
        log "restore file should be given."
        exit
    fi

    if [ -z "${rkey}" ]; then
        log "redis heartbeat key should be given."
        exit
    fi
    
    if [ ! -x "${KCMD}" -o  ! -x "${RCMD}" -o ! -x "${rstoreFile}" ]; then
        log "Invliad permission or not exist : ${KCMD} or ${RCMD}  or ${rstoreFile}"
        exit
    fi
}

getaddr(){
    p1=/opt/ericsson/nfvo/fcaps/config/fm_app/application-pro.yml
    p2=/opt/ericsson/nfvo/fcaps/config/fm_spark/app.properties
    if [ -r "${p1}" ]; then
        addr=$(cat "${p1}" | grep -Ev "^#" | grep 'bootstrap-servers' | sed -e 's#bootstrap-servers:##g' -e 's#\r\|\n##g')
        rladdr=$(cat ${p1} | grep -Ev "^#" | grep 'nodes' | awk '{print $2}'|sed -e 's#\r\n\|\r\|\n##g')
        if [ -n "${addr}" -a -n "${rladdr}" ]; then
        log "get addr: ${addr}"
        log "get redis addr: ${rladdr}"
        raddr=($(echo ${rladdr} |  sed -e 's#,# #g'))
            return
        fi
    fi

    if [ -r "${p2}" ]; then
        addr=$(cat ${p2} | grep -Ev "^#" | grep 'kafkaAddress' | cut -d= -f2| sed 's#\r\|\n##g')
        rladdr=$(cat ${p2} | grep -Ev "^#"  |grep redisAddress | awk -F= '{print $2}' | sed -e 's#\r\n\|\r\|\n##g')
        if [ -n "${addr}" -a -n "${rladdr}" ]; then
            log "get addr: ${addr}"
            log "get redis addr: ${rladdr}"
            raddr=($(echo ${rladdr} |  sed -e 's#,# #g'))
            return
        else
            log "Invalid addr."
            exit
        fi
    fi
}


calcRes(){
    if [ -z "${ifreg}" -o  "${ifreg}" == "n" ]; then
        if [ -n "${topic}" ]; then
            tt=($("${KCMD}" --bootstrap-server  ${addr}  --describe --group ${group_id} 2>>${file} | grep -E "\<${topic}\>" | awk 'BEGIN{sum1=0;sum2=0}{sum1+=$4;sum2+=$5} END{print sum1,sum2}'))
        else 
            tt=($("${KCMD}" --bootstrap-server  ${addr}  --describe --group ${group_id} 2>>${file} | awk 'BEGIN{sum1=0;sum2=0}{sum1+=$4;sum2+=$5} END{print sum1,sum2}'))
        fi
    else
        ggs=($(${KCMD} --bootstrap-server ${addr} --list | grep "${group_id}"))
        log "regex group-ids:${ggs[@]}"
        ll=$((${#ggs[@]}-1))
        if [ -z "${topic}" ]; then
            if [ "${#ggs[@]}" -gt "0" ]; then
                declare -a arr=()
                a=0
                b=0
                for i in $(seq 0 $ll)
                do
                    arr+=($("${KCMD}" --bootstrap-server  ${addr}  --describe --group ${ggs[$i]} 2>>${file} | awk 'BEGIN{sum1=0;sum2=0}{sum1+=$4;sum2+=$5} END{print sum1,sum2}'))
                done
                log "phase one=${arr[@]}"
                ll2=$((${#arr[@]}-1))
                for i in $(seq 0 2 $ll2)
                do
                    let a=a+${arr[$i]}
                    let j=i+1
                    let b=b+${arr[$j]}
                done
                tt=($a $b)
            fi
        else
            if [ "${#ggs[@]}" -gt "0" ]; then
                declare -a arr=()
                a=0
                b=0
                for i in $(seq 0 $ll)
                do
                    arr+=($("${KCMD}" --bootstrap-server ${addr} --describe --group ${ggs[$i]} 2>>${file} | grep -E "\<${topic}\>" | awk 'BEGIN{sum1=0;sum2=0}{sum1+=$4;sum2+=$5} END{print sum1,sum2}'))
                done
                log "phase one=${arr[@]}"
                ll2=$((${#arr[@]}-1))
                for i in $(seq 0 2 $ll2)
                do
                    let a=a+${arr[$i]}
                    let j=i+1
                    let b=b+${arr[$j]}
                done
                tt=($a $b)
            fi
        fi
    fi
    log "phase final=${tt[@]}"
}

monitorLag(){
    getaddr
    acquireKey
    if [ "$flag" -eq 0 ]; then
        exist 1
    fi
    tm=$(date +"%F%T")
    calcRes
    if [ "0" -eq "${tt[1]}" ]; then
        log "Lag=${tt[1]}, Consumer run well." 
        if [ "${update}" != "n" ]; then
            log "begin to update heartbeat."
            updateheartbeat
        fi
    else
        existsKey
        if [ "$exists" -eq "1" ]; then
            # check
            getLastVal "endOffset"
            if [ -n "${gval}" ]; then
                log "last endoffset=${gval}, current offset=${tt[0]}"
                if [ "${gval}" -ne "${tt[0]}" ]; then
                    saveLastConsumerVal  "endOffset"  "${tt[0]}"
                    if [ "${update}" != "n" ]; then
                        log "begin to update heartbeat."
                        updateheartbeat
                    fi
                else
                    getLastVal "time"
                    if [ -n "${gval}" ]; then
                        ggval=$(echo $gval | sed 's#\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\([0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\)#\1 \2#g')
                        ggval2=$(echo $tm | sed 's#\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\([0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\)#\1 \2#g')
                        tival=$((($(date +%s -d "$ggval2")-$(date +%s -d "$ggval"))/60))
                        log "time diff=${tival}"
                        if [ "${tival}" -ge "10" ]; then
                            log "begin to restart app."
                            $(${rstoreFile} >/dev/null 2>>${file})
                            saveLastConsumerVal "time" ""
                        fi
                    else
                        saveLastConsumerVal  "time"  "${tm}"
                    fi
                fi
            else
                saveLastConsumerVal  "endOffset"  "${tt[0]}"
            fi
        else
            # no
            saveLastConsumerVal  "endOffset"  "${tt[0]}"
            saveLastConsumerVal  "time"  "${tm}"
            if [ "${update}" != "n" ]; then
                log "begin to update heartbeat."
                updateheartbeat
            fi
        fi
            
    fi
    releaseKey
}


usage(){
    echo -e "avaliable option:  \n
                -g:  kafka consumer group id to monitor  \n
                -t:  the kafka topic to monitor correspond to consumer group  \n
                -k:  the mutex key          \n
                -c:  the script used to restore app     \n
                -u:  if update osswg heartbeat key, default no. Input avaliable: [n/y]      \n
                -r:  the redis heartbeat key to update  \n 
                -i:  should match consumer_group_id with regular, default no. Input avaliable[y/n] \n
                examlpe: \n
                script.sh -g fm-standard-group -t fm_alarm_topic -k r_lock -c /opt/ericsson/nfvo/fcaps/bin/fm_spark/restart_fm_standard.sh -u n -r fm:heartbeat:alarmstandard -i n
            "
}

# -g group_id -t topic -k mutex -c script -u [n/y]
# -g fm-standard-group -t fm_alarm_topic -k r_lock -c /opt/ericsson/nfvo/fcaps/bin/fm_spark/restart_fm_standard.sh  -u n -r fm:heartbeat:alarmstandard -i y
main(){
    update=''
    ifreg='n'
    if [ "$#" -lt "8" ]; then
        usage
        exit
    fi    
    while getopts ":g:t:k:c:u:r:i:" opt
    do
        case $opt in
        g)
            group_id=${OPTARG}
        ;;
        t)
            topic=${OPTARG}
        ;;
        k)
            mutex_lock=${OPTARG}
        ;;
        c)
            rstoreFile=${OPTARG}
        ;;
        u)
            update=${OPTARG}
            if [[! "$update" =~ [ny] ]]; then
                echo "-u should one of n/y."
                exit
            fi
        ;;
        r)
            rkey=${OPTARG}
        ;;
        i)
            ifreg=${OPTARG}
            if [[ ! "$ifreg" =~ [ny] ]]; then
                echo "-i should one of n/y."
                exit
            fi
        ;;
        *)
            usage
            exit 
        ;;
        esac
    done
    healthCheck
    if [ -z "$update" ]; then
        if [[ "$group_id" =~ "fm-standard-group" ]] && [[ "$topic" =~ "fm_alarm_topic" ]]; then
            update="y"
        fi
        
        if [ -z "$update" ] && [[ "$group_id" =~ "master-slave-group" ]] && [[ "$topic" =~ "fm_alarm_standard_topic" ]]; then
            update="n"
        fi
        if [ -z "$update" ]; then
            update="n"
        fi
    fi
    monitorLag
}

main $@