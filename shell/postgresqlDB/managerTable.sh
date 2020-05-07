#!/bin/bash
display(){
    echo "**************************"
    echo "****(1).查看数据*************"
    echo "****(2).添加数据*************"
    echo "****(3).删除数据*************"
    echo "****(4).更新数据*************"
    echo "****(q).退出*****************"
    echo "**************************"
}

usage(){
    echo "usage: $0 ip port username pwd db"
    exit 1
}

insert(){
    echo "input value: (type value if_valid)"
    read type value if_valid
    echo "${SrcConn}"
    dtime=$(date +"%F %T")
    sql="insert into filter_strategy(type, value, if_valid,update_time) values('"
    sql="${sql}$type',"
    sql="$sql'"
    sql="$sql$value',"
    sql="$sql'"
    sql="${sql}$if_valid',"
    sql="$sql'"
    sql="$sql $dtime') on conflict(type,value) do nothing;"
    psql "${SrcConn}" -c "$sql"
}

getdata(){
    echo "**********************"
    echo "*****1.Get All********"
    echo "*****2.Get with id****"
    echo "**********************"
    read opg
    case $opg in
    1)
    psql "${SrcConn}" -c "select * from filter_strategy;"
    ;;
    2)
    echo "input value like: type value"
    read ttg valg
    sqlq="select * from  filter_strategy where type='"
    sqlq="${sqlq}$ttg' and value='"
    sqlq="${sqlq}$valg';"
    psql "${SrcConn}" -c "${sqlq}"
    ;;
    *)
    echo "input value within (1,2)"
    ;;
    esac
}

deldata(){
    echo "**********************"
    echo "*****1.Delete All********"
    echo "*****2.Delete with id****"
    echo "**********************"
    read opd
    
    case $opd in
    1)
    psql "${SrcConn}" -c "delete from filter_strategy;"
    ;;
    2)
    echo "input value like: type value"
    read ttd vald
    sqld="delete from  filter_strategy where type='"
    sqld="${sqld}$ttd' and value="
    sqld="${sqld}'"
    sqld="${sqld}$vald';"
    psql "${SrcConn}" -c "$sqld"
    ;;
    *)
    echo "input value within (1,2)"
    ;;
    esac
}

update(){
    echo "update with id, Input value like: type value if_valid"
    read ttu valu validu
    dtimeu=$(date +"%F %T")
    sqlu="update filter_strategy set if_valid='"
    sqlu="${sqlu}${validu}',update_time='"
    sqlu="${sqlu}${dtimeu}' where type='"
    sqlu="${sqlu}$ttd' and value='"
    sqlu="${sqlu}${valu}';"
    psql "${SrcConn}" -c  "$sqlu"
}


process(){
    case $1 in 
    1)
    getdata
    ;;
    2)
    insert
    ;;
    3)
    deldata
    ;;
    4)
    update
    ;;
    q)
    echo "quit"
    exit 0
    ;;
    *)
    echo "select in  (1,2,3,4,q)"
    ;;
    esac
}

main(){
    if [ $# -lt 5 ];then
        usage
    fi
    ip=$1 
    port=$2 
    username=$3
    pwd=$4
    db=$5
    SrcConn="host=$ip port=$port user=$username password=$pwd dbname=$db"
    while true
    do
        display
        read opt
        process $opt
    done

}

main $@