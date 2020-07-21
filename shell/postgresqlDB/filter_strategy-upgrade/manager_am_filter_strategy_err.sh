#!/bin/bash
display(){
    echo "*********************************************************"
    echo "****l.list data"
    echo "****i.insert data"
    echo "****d.delete data"
    echo "****u.update data"
    echo "****q.quit"
    echo "**Data changes will take effect in 60 seconds."
    echo "*********************************************************"
}

usage(){
    echo "usage: $0 -h ip -p port -u username -s pwd -d db"
    exit 1
}

### 这里执行的时候, getopts始终获取到值, case就没有执行, 目前没有找到原因
gsql(){
dtime=$(date +"%F%T")
iidx=("update_time")
iival=($dtime) 
    while getopts ":s:a:o:t:u:r:e:" iiopt
    do
        case ${iiopt} in
            s)
            iidx+=("source_id")
            iival+=($OPTARG)
            ;;
            a)
            iidx+=("alarm_type")
            iival+=($OPTARG)
            ;;
            o)
            iidx+=("orig_severity")
            iival+=($OPTARG)
            ;;
            t)
            iidx+=("object_type")
            iival+=($OPTARG)
            ;;
            u)
            iidx+=("object_uid")
            iival+=($OPTARG)
            ;;
            r)
            iidx+=("start_time")
            iival+=($OPTARG)
            ;;
            e)
            iidx+=("end_time")
            iival+=($OPTARG)
            ;;
            *)
            echo "Invalid input."
            ;;
        esac
    done

iisql="insert into filter_strategy_upgrade("
iisqlv=" values("
let ll=${#iidx[@]}-1
for i in $(seq 0 $ll)
do
    iisql+="${iidx[$i]},"
    iisqlv+="${iival[$i]},"
done
iisql=${iisql:0:${#iisql}}
iisqlv=${iisqlv:0:${#iisqlv}}
echo "sql = $iisql"
echo "sql = $iisqlv"
}

insert(){
echo 'input value: -s source_id -a alarm_type -o orig_severity(critical,major,minor,warning,null) -t object_type -u object_uid  -r start_time -e end_time (time format:"2020-01-0100:00:00")'
read -p "input value: " -a vals
gsql ${vals[@]}

}


insertAll(){
    echo 'input value: source_id  alarm_type  orig_severity(critical,major,minor,warning,null)  object_type object_uid  start_time end_time (time format:"2020-01-01\ 00:00:00")'
    read isid ialarmtype iorigserver iobjtype iobjuid istime ietime
    #echo "source_id=${isid}, alarm_type=${ialarmtype},orig_severity=${iorigserver},object_type=${iobjtype},object_uid=${iobjuid},start_time=${istime},end_time=${ietime}"
    if [ "${iorigserver}" != "critical" ] && [ "${iorigserver}" != "major" ] && [ "${iorigserver}" != "minor" ] && [ "${iorigserver}" != "warning" ] && [ "${iorigserver}" != "null" ] ; then
        echo "orig_severity should in (critical,major,minor,warning,null)"
        return
    fi
    OIFS="${IFS}"
    IFS="#"
    dtime=$(date +"%F %T")
    iargs=($isid#$ialarmtype#$iorigserver#$iobjtype#$iobjuid#$istime#$ietime#$dtime)
    sql="insert into filter_strategy_upgrade(source_id,alarm_type,orig_severity,object_type,object_uid,start_time,end_time,update_time) values('"
    for i in ${iargs[@]}
    do
        if [ "$i" == "${dtime}" ]; then
            sql="${sql}$i'"
        else 
            sql="${sql}$i',"
            sql="$sql'"
        fi
    done
    #echo "sql = $sql"
    IFS=${OIFS}
    psql "${SrcConn}" -c "${sql});"
}

getdata(){
    echo "**********************"
    echo "******a.Get All"
    echo "******s.Get with id"
    echo "**********************"
    read opg
    case $opg in
    a)
    psql "${SrcConn}" -c "select * from filter_strategy_upgrade;"
    ;;
    s)
    echo "input value: auto_id (primary key)"
    read gid
    sqlq="select * from  filter_strategy_upgrade where auto_id='"
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
    psql "${SrcConn}" -c "delete from filter_strategy_upgrade;"
    ;;
    s)
    echo "input value: auto_id (primary key)"
    read did
    sqld="delete from  filter_strategy_upgrade where auto_id='"
    sqld="${sqld}$did'"
    psql "${SrcConn}" -c "$sqld"
    ;;
    *)
    echo "input value is invalid, should be a/s"
    ;;
    esac
}



updateAll(){
    echo 'update with id, Input value: auto_id(primary key) source_id  alarm_type  orig_severity(critical,major,minor,warning,null)  object_type object_uid  start_time end_time (time format:"2020-01-01\ 00:00:00")'
    read uaid usid ualarmtype uorigserver uobjtype uobjuid ustime uetime
    #echo "auto_id=${uaid},source_id=${usid},alarm_type=${ualarmtype},orig_severity=${uorigserver},object_type=${uobjtype},object_uid=${uobjuid},start_time=${ustime},end_time=${uetime}"
    if [ "${uorigserver}" != "critical" ] && [ "${uorigserver}" != "major" ] && [ "${uorigserver}" != "minor" ] && [ "${uorigserver}" != "warning" ] && [ "${uorigserver}" != "null" ] ; then
        echo "orig_severity should in (critical,major,minor,warning,null)"
        return
    fi
    OIFS="${IFS}"
    IFS="#"
    dtimeu=$(date +"%F %T")
    uargs=(source_id=\'${usid}\'#alarm_type=\'${ualarmtype}\'#orig_severity=\'${uorigserver}\'#object_type=\'${uobjtype}\'#object_uid=\'${uobjuid}\'#start_time=\'${ustime}\'#end_time=\'${uetime}\')
    leth=${#uargs[@]}
    sqlu="update filter_strategy_upgrade set "
    for i in ${uargs[@]}
    do
            sqlu="${sqlu}${i},"
    done
    sqlu="${sqlu}update_time='"
    sqlu="${sqlu}${dtimeu}'"
    #echo "sqlu = ${sqlu}"
    IFS=${OIFS}
    psql "${SrcConn}" -c  "${sqlu} where auto_id=${uaid} ;"
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
