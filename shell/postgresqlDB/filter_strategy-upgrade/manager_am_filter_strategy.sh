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

insert(){
    echo 'input value: source_id  alarm_type  orig_serverity(critical,major,minor,warning,null)  object_type object_uid  start_time end_time (time format:"2020-01-01 00:00:00")'
    read type value istime ietime
    echo "type=${type}, value=${value},isTime = ${istime}, ietime=${ietime}"
    #echo "${SrcConn}"
    dtime=$(date +"%F %T")
    sql="insert into filter_strategy_upgrade(source_id,alarm_type,orig_serverity,object_type,object_uid,start_time,end_time,update_time) values('"
    sql="${sql}$type',"
    sql="$sql'"
    sql="$sql$value',"
    sql="$sql'"
    sql="${sql}${istime}',"
    sql="$sql'"
    sql="${sql}${ietime}',"
    sql="$sql'"
    sql="$sql $dtime');"
    psql "${SrcConn}" -c "$sql"
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

update(){
    echo 'update with id, Input value: auto_id(primary key) source_id alarm_type orig_serverity object_type object_uid start_time end_time (time format:"2020-01-01 00:00:00")'
    read uid ttu valu stime etime
    dtimeu=$(date +"%F %T")
    sqlu="update filter_strategy_upgrade set update_time='"
    sqlu="${sqlu}${dtimeu}', type='"
    sqlu="${sqlu}$ttu',value='"
    sqlu="${sqlu}${valu}',start_time='"
    sqlu="${sqlu}${stime}',end_time='"
    sqlu="${sqlu}${etime}' where auto_id='"
    sqlu="${sqlu}${uid}';"
    psql "${SrcConn}" -c  "$sqlu"
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
