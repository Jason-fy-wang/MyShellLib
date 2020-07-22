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

gsql(){
    dtime=$(date +"%F%T")
    iidx=("update_time")
    iival=("$dtime")
    oper=$1
    shift
    while [ -n "$1" ] 
    do
        case ${1} in
            -s)
            iidx+=("source_id")
            iival+=(\'$2\')
            ;;
            -a)
            iidx+=("alarm_type")
            iival+=(\'$2\')
            ;;
            -o)
            if [ "${2}" != "critical" ] && [ "${2}" != "major" ] && [ "${2}" != "minor" ] && [ "${2}" != "warning" ] && [ "${2}" != "null" ] ; then
                echo "orig_severity should in (critical,major,minor,warning,null)"
                return 1
            fi
            iidx+=("orig_severity")
            iival+=(\'$2\')
            ;;
            -t)
            iidx+=("object_type")
            iival+=(\'$2\')
            ;;
            -u)
            iidx+=("object_uid")
            iival+=(\'$2\')
            ;;
            -r)
            iidx+=("start_time")
            iival+=($2)
            ;;
            -e)
            iidx+=("end_time")
            iival+=($2)
            ;;
            -d)
            if [ "$oper" == "it" ];then
                echo "Insert don't need auto_id.."
                return 1
            fi
            iidx+=("auto_id")
            iival+=($2)
            ;;
            *)
            echo "Invalid input."
            ;;
        esac
        shift 2
    done
let ll=${#iidx[@]}-1
}

update(){
    echo 'input value: -d auto_id -s source_id -a alarm_type -o orig_severity(critical,major,minor,warning,null) -t object_type -u object_uid  -r start_time -e end_time (time format:"2020-01-0100:00:00")'
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

    iisql="update filter_strategy_upgrade set "
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
        else 
            iisql+="${iidx[$i]}="
            iisql+="${iival[$i]},"
        fi
    done
    iisql=${iisql:0:$(expr ${#iisql}-1)}
    iisql+="$uuwh"
    psql "${SrcConn}" -c "${iisql} "
}


insert(){
    echo 'input value: -s source_id -a alarm_type -o orig_severity(critical,major,minor,warning,null) -t object_type -u object_uid  -r start_time -e end_time (time format:"2020-01-0100:00:00")'
    read -p "input value: " -a vals
    gsql it ${vals[@]}
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
        echo "update_time and start_time must be given.."
        return
    fi

    iisql="insert into filter_strategy_upgrade("
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
    iisql=${iisql:0:$(expr ${#iisql}-1)}
    iisqlv=${iisqlv:0:$(expr ${#iisqlv}-1)}
    iisql+=")"
    iisql+="$iisqlv"
    psql "${SrcConn}" -c "${iisql});"

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
