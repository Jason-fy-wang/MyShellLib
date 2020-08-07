#!/bin/bash
GROUP=fm-standard-group
TOPIC=fm_alarm_topic
SCRIPT=/opt/ericsson/nfvo/fcaps/bin/fm_spark/restart_fm_standard.sh
CMD=/opt/kafka-2.11/bin/kafka-consumer-groups.sh
LOGPath=/opt/ericsson/nfvo/fcaps/runtime_log/tools
nn=$(echo "$0" | sed 's#.sh##g')
file=${LOGPath}/${nn}-$(date +'%Y%m%d').log
log(){
    echo "$(date +'%F %T'):  $@" >> ${file}
}

healthCheck(){
    if [ ! -d "${LOGPath}" ]; then
        echo "Please create dir first: ${LOGPath}"
        exit
    fi

    if [ ! -x "${SCRIPT}" ]; then
        log "Invliad permission or not exist : ${SCRIPT}"
        exit
    fi

    if [ ! -x "${CMD}" ]; then
        log "Invliad permission or not exist : ${CMD}"
        exit
    fi
}

getaddr(){
    p1=/opt/ericsson/nfvo/fcaps/config/fm_app/application-pro.yml
    p2=/opt/ericsson/nfvo/fcaps/config/fm_spark/app.properties
    if [ -r "${p1}" ]; then
        addr=$(cat "${p1}" | grep 'bootstrap-servers' | sed -e 's#bootstrap-servers:##g' -e 's#\r\|\n##g')
        if [ -n "${addr}" ]; then
        log "get addr: ${addr}"
            return
        fi
    fi

    if [ -r "${p2}" ]; then
        addr=$(cat ${p2} | grep 'kafkaAddress' | cut -d= -f2| sed 's#\r\|\n##g')
        if [ -n "${addr}" ]; then
            log "get addr: ${addr}"
            return
        else
            log "Invalid addr."
            exit
        fi
    fi
}


monitorLag(){
    count=0
    flag=1
    LAST_END=0
    getaddr
    for i in $(seq 1 10)
    do
        log "times=${i}"
        tt=($("${CMD}" --bootstrap-server  ${addr}  --describe --group ${GROUP} 2>>${file} | grep -E "\<${TOPIC}\>" | awk 'BEGIN{sum1=0;sum2=0}{sum1+=$4;sum2+=$5} END{print sum1,sum2}')) 
        if [ "0" -eq "${tt[1]}" ]; then
            log "Lag=${tt[1]}, Consumer run well." 
        else
            log "count=${count}, last_offset_sum=${LAST_END},currnet_offset_sum=${tt[0]}, Lag=${tt[1]}"
            if [ "$flag" -eq "1" ]; then
                let flag++
                LAST_END=${tt[0]}
            else
                if [ "${LAST_END}" -ne "${tt[0]}" ]; then
                    LAST_END=${tt[0]}
                    count=0
                else
                    let count++
                fi
            fi
        fi

        if [ "${count}" -ge "10" ]; then
            log "count=${count}, begin to restart app."
            count=0
            $(${SCRIPT} >/dev/null 2>&1) 
        fi

        sleep 60 
    done
}


main(){
 healthCheck
 monitorLag
}

main