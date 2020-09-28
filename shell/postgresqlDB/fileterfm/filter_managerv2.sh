#!/bin/bash
RCMD="/opt/redis-5.0.0/6379/redis-cli"
display(){
    echo "*********************************************************"
    echo "****l.list data"
    echo "****i.insert data"
    echo "****d.delete data"
    echo "****u.update data"
    echo "****q.quit"
    echo "*********************************************************"
}

usage(){
    echo "usage: $0 -h ip -p port -u username -s pwd -d db"
    exit 1
}

gsql(){
    dtime=$(date +"%F%T")
    iidx=("update_time")
    iival=("$dtime")
    oper=$1
    rdsva="{\"sourceId\":null,\"alarmType\":null,\"origSeverity\":null,\"objectType\":null,\"objectName\":null,\"objectUid\":null,\"alarmId\":null,\"alarmStatus\":null,\"startTime\":null,\"endTime\":null, \"updateTime\":\"${dtime}\"}"
    shift
    while [ -n "$1" ]
    do
        case ${1} in
            -s)
            ttp="source_id"
            ttp2="sourceId"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp2}\":\)\(null\)#\1\"$2\"#")
            iidx+=(${ttp})
            iival+=(\'$2\')
            ;;
            -a)
            ttp="alarm_type"
            ttp2="alarmType"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp2}\":\)\(null\)#\1\"$2\"#")
            iidx+=(${ttp})
            iival+=(\'$2\')
            ;;
            -o)
            if [[ ! "${2}" =~ [critical|major|minor|warning|null] ]] ; then
                echo "orig_severity should in (critical,major,minor,warning,null)"
                return 1
            fi
            ttp="orig_severity"
            ttp2="origSeverity"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp2}\":\)\(null\)#\1\"$2\"#")
            iidx+=(${ttp})
            iival+=(\'$2\')
            ;;
            -t)
            ttp="object_type"
            ttp2="objectType"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp2}\":\)\(null\)#\1\"$2\"#")
            iidx+=(${ttp})
            iival+=(\'$2\')
            ;;
            -n)
            ttp="object_name"
            ttp2="objectName"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp2}\":\)\(null\)#\1\"$2\"#")
            iidx+=(${ttp})
            iival+=(\'$2\')
             ;;
            -u)
            ttp="object_uid"
            ttp2="objectUid"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp2}\":\)\(null\)#\1\"$2\"#")
            iidx+=(${ttp})
            iival+=(\'$2\')
            ;;
            -d)
            ttp="alarm_id"
            ttp2="alarmId"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp2}\":\)\(null\)#\1\"$2\"#")
            iidx+=(${ttp})
            iival+=(\'$2\') 
            ;;
            -f)
            ttp="alarm_status"
            ttp2="alarmStatus"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp2}\":\)\(null\)#\1\"$2\"#")
            iidx+=(${ttp})
            if [[ ! "$2" =~ [0-1]{1} ]]; then
                echo "alarm_status shoud select in (0,1)"
                return 1
            fi
            tvv=$(echo $2 | sed -e 's#\([0-9]{1}\)#\1#' -e 's#"##g' -e "s#'##g")
            iival+=(\'${tvv}\')
             ;;
            -r)
            ttp="start_time"
            ttp2="startTime"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp2}\":\)\(null\)#\1\"$2\"#")
            iidx+=(${ttp})
            iival+=($2)
            ;;
            -e)
            ttp="end_time"
            ttp2="endTime"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp2}\":\)\(null\)#\1\"$2\"#")
            iidx+=(${ttp})
            iival+=($2)
            ;;
            -w)
            if [ "$oper" == "it" ];then
                echo "Insert don't need auto_id.."
                return 1
            fi
            ttp="auto_id"
            ttp2="autoId"
            iidx+=(${ttp})
            iival+=($2)
            aid=$2
            ;;
            *)
            echo "Invalid input."
	        return 1
            ;;
        esac
        shift 2
    done
let ll=${#iidx[@]}-1
}

getaddr(){
    p1=/opt/ericsson/nfvo/fcaps/config/fm_app/application-pro.yml
    p2=/opt/ericsson/nfvo/fcaps/config/fm_spark/app.properties
    if [ -r "${p1}" ]; then
        rladdr=$(cat ${p1} | grep -Ev "^#" | grep 'nodes' | awk '{print $2}'|sed -e 's#\r\n\|\r\|\n##g')
        if [ -n "${rladdr}" ]; then
        # echo "get redis addr: ${rladdr}"
        raddr=($(echo ${rladdr} |  sed -e 's#,# #g'))
            return
        fi
    fi

    if [ -r "${p2}" ]; then
        rladdr=$(cat ${p2} | grep -Ev "^#"  |grep redisAddress | awk -F= '{print $2}' | sed -e 's#\r\n\|\r\|\n##g')
        if [ -n "${rladdr}" ]; then
            # echo "get redis addr: ${rladdr}"
            raddr=($(echo ${rladdr} |  sed -e 's#,# #g'))
            return
        else
            echo "Invalid redis addr."
            exit
        fi
    fi
}

setVal(){
    getaddr
    valKey="fm:alarm:filter:strategy"
    for ar in ${raddr}
    do  
        s=$(echo ${ar} | cut -d: -f1)
        p=$(echo ${ar} | cut -d: -f2)
        res=$(${RCMD} -h $s -p $p -c hset  ${valKey} ${1} "${2}" 2>&1)
        # echo "save res=$res"
        echo $res | grep "$s" >/dev/null 2>&1
        if [ "$?" -gt "0" ]; then
            echo $res | grep -E "OK|[0-9]{1,}" >/dev/null 2>&1
            if [ "$?" -eq "0" ]; then
                break
            fi
        fi
    done
}

delkey(){
    getaddr
    valKey="fm:alarm:filter:strategy"
    for ar in ${raddr}
    do  
        s=$(echo ${ar} | cut -d: -f1)
        p=$(echo ${ar} | cut -d: -f2)
        res=$(${RCMD} -h $s -p $p -c del ${valKey} 2>&1)
        # echo "save res=$res"
        echo $res | grep "$s" >/dev/null 2>&1
        if [ "$?" -gt "0" ]; then
            echo $res | grep -E "OK|[0-9]{1,}" >/dev/null 2>&1
            if [ "$?" -eq "0" ]; then
                break
            fi
        fi
    done
}

delfield(){
    getaddr
    valKey="fm:alarm:filter:strategy"
    for ar in ${raddr}
    do  
        s=$(echo ${ar} | cut -d: -f1)
        p=$(echo ${ar} | cut -d: -f2)
        res=$(${RCMD} -h $s -p $p -c hdel ${valKey} $1 2>&1)
        # echo "save res=$res"
        echo $res | grep "$s" >/dev/null 2>&1
        if [ "$?" -gt "0" ]; then
            echo $res | grep -E "OK|[0-9]{1,}" >/dev/null 2>&1
            if [ "$?" -eq "0" ]; then
                break
            fi
        fi
    done
}


update(){
    echo 'input value: -w auto_id -s source_id -a alarm_type -o orig_severity(critical,major,minor,warning,null) -t object_type -n object_name -u object_uid  -d alarm_id -f alarm_status -r start_time -e end_time (time format:"2020-01-0100:00:00")'
    read -p "input value: " -a vals
    gsql up ${vals[@]}
    if [ "$?" -ne "0" ]; then
        return 
    fi
    cc=0
    for i in $(seq 0 $ll)
    do
        if [  "${iidx[$i]}" == "auto_id" ]; then
            let cc++
        fi
    done
    
    if [ "$cc" -ne "1" ];then
        echo "auto_id must be given.."
        return 1
    fi

    iisql="update filter_strategy set "
    uuwh=" where auto_id="
    for i in $(seq 0 $ll)
    do
        if [  "${iidx[$i]}" == "update_time" ]; then
            iisql+="${iidx[$i]}="
            iisql+="'"
            iisql+="$(echo "${iival[$i]}" | sed -n "s#\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(.*\)#\1 \2#p") ',"
        elif  [  "${iidx[$i]}" == "start_time" ]; then
            iisql+="${iidx[$i]}="
            iisql+="'"
            iisql+="$(echo "${iival[$i]}" | sed -n "s#\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(.*\)#\1 \2#p") ',"
        elif  [  "${iidx[$i]}" == "end_time" ]; then
            iisql+="${iidx[$i]}="
            iisql+="'"
            iisql+="$(echo "${iival[$i]}" | sed -n "s#\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(.*\)#\1 \2#p") ',"
        elif  [  "${iidx[$i]}" == "auto_id" ]; then
            uuwh+="${iival[$i]};"
            autd="${iival[$i]}"
        else 
            iisql+="${iidx[$i]}="
            iisql+="${iival[$i]},"
        fi
    done
    iisql=${iisql:0:$(expr ${#iisql}-1)}
    iisql+="$uuwh"
    psql "${SrcConn}" -c "${iisql} "
    if [ "$?" -eq "0" ]; then
        updaterval ${autd}
    fi
}

updaterval(){
    ad=$1
    ucmd="select case when coalesce(source_id,'')='' then concat('\"sourceId\":','null') else concat('\"sourceId\":','\"',source_id,'\"') end, case when coalesce(alarm_type,'')='' then concat('\"alarmType\":','null') else concat('\"alarmType\":','\"',alarm_type,'\"') end, case when coalesce(orig_severity,'')='' then concat('\"origSeverity\":','null') else concat('\"origSeverity\":','\"',orig_severity,'\"') end, case when coalesce(object_type,'')='' then concat('\"objectType\":','null') else concat('\"objectType\":','\"',object_type,'\"') end,case when coalesce(object_name,'')='' then concat('\"objectName\":','null') else concat('\"objectName\":','\"',object_name,'\"') end, case when coalesce(object_uid,'')='' then concat('\"objectUid\":','null') else concat('\"objectUid\":','\"',object_uid,'\"') end,case when coalesce(alarm_id,'')='' then concat('\"alarmId\":','null') else concat('\"alarmId\":','\"',alarm_id,'\"') end,case when coalesce(alarm_status,'-1')='-1' then concat('\"alarmStatus\":','null') else concat('\"alarmStatus\":','\"',alarm_status,'\"') end,concat('\"startTime\":','\"',to_char(start_time,'YYYY-MM-DDHH:MI:SS'),'\"'),concat('\"endTime\":','\"',to_char(end_time,'YYYY-MM-DDHH:MI:SS'),'\"'),concat('\"updateTime\":','\"',to_char(update_time,'YYYY-MM-DDHH:MI:SS'),'\"')from filter_strategy where auto_id=${aid}"
    uval=$(psql "${SrcConn}" -c "${ucmd}" )
    #ff=$(echo $uval | grep -Ev '^$' | grep -v 'concat'| grep -Ev '^[-(]' | sed 's#\(.*\)#{\1}#')
    #ff=$(echo $uval |sed -e 's#\bconcat\b##g' -e 's#|##g' -e 's#[-+]*##g' -e 's#, (1 row)##g')
    ff=$(echo $uval | awk -F"- " '{print $2}' | sed -e 's#(1 row)##g' -e 's#|#,#g' -e  's#\(.*\)#{\1}#')
    setVal ${ad} "${ff}"
}

insert(){
    echo 'input value: -s source_id -a alarm_type -o orig_severity(critical,major,minor,warning,null) -t object_type -n object_name -u object_uid -d alarm_id -f alarm_status -r start_time -e end_time (time format:"2020-01-0100:00:00")'
    read -p "input value: " -a vals
    gsql it ${vals[@]}
    # echo "rdsva == ${rdsva}"
    if [ "$?" -ne "0" ]; then
        return 
    fi

    cc=0
    for i in $(seq 0 $ll)
    do
        if [  "${iidx[$i]}" == "end_time" ]; then
            let cc++
        elif  [  "${iidx[$i]}" == "start_time" ]; then
            let cc++
        fi
    done
    if [ "$cc" -ne "2" ]; then
        echo "start_time and end_time must be given.."
        return
    fi
    ocmd="select nextval('filter_strategy_auto_id_seq'::regclass);"
    iisql="insert into filter_strategy("
    iisqlv=" values("
    for i in $(seq 0 $ll)
    do
        if [  "${iidx[$i]}" == "update_time" ]; then
            iisql+="${iidx[$i]},"
            iisqlv+="'"
            iisqlv+="$(echo "${iival[$i]}" | sed -n "s#\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(.*\)#\1 \2#p")"
            iisqlv+="',"
        elif  [  "${iidx[$i]}" == "start_time" ]; then
            iisql+="${iidx[$i]},"
            iisqlv+="'"
            iisqlv+="$(echo "${iival[$i]}" | sed -n "s#\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(.*\)#\1 \2#p")"
            iisqlv+="',"
        elif  [  "${iidx[$i]}" == "end_time" ]; then
            iisql+="${iidx[$i]},"
            iisqlv+="'"
            iisqlv+="$(echo "${iival[$i]}" | sed -n "s#\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(.*\)#\1 \2#p")"
            iisqlv+="',"
        else 
            iisql+="${iidx[$i]},"
            iisqlv+="${iival[$i]},"
        fi
    done
    vtm=$(psql "${SrcConn}" -c "${ocmd}" | grep -E '^\( | [0-9]{1}')
    # echo "vtm value = ${vtm}"
    iisql+="auto_id,"
    iisqlv+="${vtm},"
    iisql=${iisql:0:$(expr ${#iisql}-1)}
    iisqlv=${iisqlv:0:$(expr ${#iisqlv}-1)}
    iisql+=")"
    iisql+="$iisqlv"
    psql "${SrcConn}" -c "${iisql});"
    if [ "$?" -eq "0" ]; then
        setVal $vtm  "${rdsva}"
    fi
}

getdata(){
    echo "**********************"
    echo "******a.Get All"
    echo "******s.Get with id"
    echo "**********************"
    read opg
    case $opg in
    a)
    psql "${SrcConn}" -c "select * from filter_strategy;"
    ;;
    s)
    echo "input value: auto_id (primary key)"
    read gid
    sqlq="select * from  filter_strategy where auto_id='"
    sqlq="${sqlq}$gid'"
    psql "${SrcConn}" -c "${sqlq}"
    ;;
    *)
    echo "input value is invalid, should be a/s"
    ;;
    esac
}

deldata(){
    echo "**********************"
    echo "******a.Delete All"
    echo "******s.Delete with id"
    echo "**********************"
    read opd

    case $opd in
    a)
    psql "${SrcConn}" -c "delete from filter_strategy;"
     if [ "$?" -eq "0" ]; then
        delkey
     fi
    ;;
    s)
    echo "input value: auto_id (primary key)"
    read did
    sqld="delete from  filter_strategy where auto_id='"
    sqld="${sqld}$did'"
    psql "${SrcConn}" -c "$sqld"
    if [ "$?" -eq "0" ]; then
        delfield $did
    fi
    ;;
    *)
    echo "input value is invalid, should be a/s"
    ;;
    esac
}

check(){
    if [ ! -x "$RCMD" ]; then
        echo "Command : $RCMD  should config."
        exit 1
    fi
}

process(){
    case $1 in
    l)
    getdata
    ;;
    i)
    insert
    ;;
    d)
    deldata
    ;;
    u)
    update
    ;;
    q)
    echo "quit"
    exit 0
    ;;
    *)
    echo "input value is invalid, should be l/i/u/d/q"
    ;;
    esac
}

main(){
    if [ $# -lt 5 ];then
        usage
    fi
    while getopts ":h:p:u:s:d:" opt
    do
        case $opt in
        h)ip=$OPTARG;;
        p)port=$OPTARG;;
        u)username=$OPTARG;;
        s)pwd=$OPTARG;;
        d)db=$OPTARG;;
        ?) usage 
            exit 1    
        ;;
        esac
    done
    SrcConn="host=$ip port=$port user=$username password=$pwd dbname=$db"
    clear
    check
    while true
    do
        display
        read opr
        process $opr
    done

}

main $@

