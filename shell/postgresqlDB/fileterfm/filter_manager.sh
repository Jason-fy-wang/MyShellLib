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
    rdsva="{\"source_id\":\"\",\"alarm_type\":\"\",\"orig_severity\":\"\",\"object_type\":\"\",\"object_name\":\"\",\"object_uid\":\"\",\"alarm_id\":\"\",\"alarm_status\":\"\",\"start_time\":\"\",\"end_time\":\"\", \"update_time\":\"${dtime}\"}"
    shift
    while [ -n "$1" ]
    do
        case ${1} in
            -s)
            ttp="source_id"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp}\":\)\(\"\"\)#\1$2#")
            iidx+=(${ttp})
            iival+=(\'$2\')
            ;;
            -a)
            ttp="alarm_type"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp}\":\)\(\"\"\)#\1$2#")
            iidx+=(${ttp})
            iival+=(\'$2\')
            ;;
            -o)
            if [[ ! "${2}" =~ [critical|major|minor|warning|null] ]] ; then
                echo "orig_severity should in (critical,major,minor,warning,null)"
                return 1
            fi
            ttp="orig_severity"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp}\":\)\(\"\"\)#\1$2#")
            iidx+=(${ttp})
            iival+=(\'$2\')
            ;;
            -t)
            ttp="object_type"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp}\":\)\(\"\"\)#\1$2#")
            iidx+=(${ttp})
            iival+=(\'$2\')
            ;;
            -n)
            ttp="object_name"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp}\":\)\(\"\"\)#\1$2#")
            iidx+=(${ttp})
            iival+=(\'$2\')
             ;;
            -u)
            ttp="object_uid"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp}\":\)\(\"\"\)#\1$2#")
            iidx+=(${ttp})
            iival+=(\'$2\')
            ;;
            -d)
            ttp="alarm_id"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp}\":\)\(\"\"\)#\1$2#")
            iidx+=(${ttp})
            iival+=(\'$2\') 
            ;;
            -f)
            ttp="alarm_status"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp}\":\)\(\"\"\)#\1$2#")
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
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp}\":\)\(\"\"\)#\1$2#")
            iidx+=(${ttp})
            iival+=($2)
            ;;
            -e)
            ttp="end_time"
            rdsva=$(echo $rdsva |sed -e "s#\(\"${ttp}\":\)\(\"\"\)#\1$2#")
            iidx+=(${ttp})
            iival+=($2)
            ;;
            -w)
            if [ "$oper" == "it" ];then
                echo "Insert don't need auto_id.."
                return 1
            fi
            ttp="auto_id"
            iidx+=(${ttp})
            iival+=($2)
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
        res=$(${RCMD} -h $s -p $p -c hset  ${valKey} ${1} "${2}" EX 604800 2>&1)
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
    ucmd="select concat('\"source_id\":',source_id),concat('\"alarm_type\":',alarm_type),concat('\"orig_severity\":',orig_severity),concat('\"object_type\":',object_type), concat('\"object_name\":',object_name),concat('\"object_uid\":',object_uid),concat('\"alarm_id\":',alarm_id),concat('\"alarm_status\":','\"',alarm_status,'\"'),concat('\"start_time\":','\"',to_char(start_time,'YYYY-MM-DDHH:MI:SS'),'\"'),concat('\"end_time\":','\"',to_char(end_time,'YYYY-MM-DDHH:MI:SS'),'\"'),concat('\"update_time\":','\"',to_char(update_time,'YYYY-MM-DDHH:MI:SS'),'\"')from filter_strategy where auto_id=21"
    uval=$(psql "${SrcConn}" -c "${ucmd}" )
    ff=$(echo $uval | sed 's#\(.*\)#{\1}#')
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
    while true
    do
        display
        read opr
        process $opr
    done

}

main $@

