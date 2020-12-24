#!/usr/bin/env bash

EFM_SERVICE=efm-2.1
PPAS_SERVICE=ppas-9.5

PG_HOME=/var/lib/ppas
PG_DATA=${PG_HOME}/9.5/data
PG_PORT=5432
PG_BIN=/usr/ppas-9.5/bin/
PG_TBL_SPACE=/app/edb/tablespaces
PG_XLOG=/rdb_xlog/pg_xlog
PG_EDBWAL_MOUNT=/mnt/edbwal

EFM_BIN=/usr/efm-2.1/bin/

ACTIVE_VIP=rdb_vip_active

SUDO_EDB=""
if [ "$(whoami)" != "enterprisedb" ]; then
    SUDO_EDB="sudo -u enterprisedb -i"
fi

copy_pub_keys() {
    if [ ! -z ${SUDO_USER} ]; then
        sudo cat ${PG_HOME}/.ssh/authorized_keys | ssh -l ${SUDO_USER} -i ~${SUDO_USER}/.ssh/id_rsa -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null ${ACTIVE_VIP} "sudo /root/.distribute_keys.sh enterprisedb" || exit 1
    else
        cat ${PG_HOME}/.ssh/authorized_keys | ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null ${ACTIVE_VIP} "/root/.distribute_keys.sh enterprisedb" || exit 1
    fi
}
verify_active_vip() {
    if ! (ping -c 1 ${ACTIVE_VIP} > /dev/null); then
        echo "unable to connect to active site VIP host: ${ACTIVE_VIP}" 1>&2
        exit 1
    fi
}

clear_pg_data() {
    # clean data
    sudo rm -rf ${PG_DATA}/*
    sudo rm -rf ${PG_TBL_SPACE}/*
    sudo rm -rf ${PG_XLOG}/*
}

remove_all_archived_wals() {
    ${SUDO_EDB} find ${PG_EDBWAL_MOUNT}/{standby1,standby2,passive_site}/ -type f -delete
}

sql_exec() {
    local HOST=$1
    local SQL_STATEMENT=$2
    ${SUDO_EDB} psql -p 5432 -h ${HOST} edb -A -t -c "${SQL_STATEMENT}"
}

copy_pg_data() {
    local HOST=$1
    ${SUDO_EDB} ${PG_BIN}/pg_basebackup -h ${HOST} -p ${PG_PORT} -P -R -D ${PG_DATA} --xlog-method=stream --xlogdir=${PG_XLOG}
}
prepare_passive_site_cluster() {
    copy_pub_keys
    sudo ${EFM_BIN}/efm stop-cluster efm
    sudo systemctl stop ${PPAS_SERVICE}
    remove_all_archived_wals
}

reinit_as_passive_master() {
    verify_active_vip
    # stop efm on passive site
    if (systemctl -q is-active ${EFM_SERVICE}); then
        echo "EFM service should be stopped" 1>&2
        return 1
    fi

    clear_pg_data

    # copy all from active site
    copy_pg_data ${ACTIVE_VIP}

    # enable archive always
    sudo sed -i "s/archive_mode = on/archive_mode = always/" ${PG_DATA}/postgresql.conf
    ${SUDO_EDB} ${PG_DATA}/gen_recovery_conf.sh  --nominal-master ${ACTIVE_VIP} passive_site

    sudo systemctl start ${PPAS_SERVICE}
}
:<<0
这里的passive master即指archive_mode设置为always的slave
当archive_mode设置为always时,其从master复制的数据也会被archive,所以此slave备份是
比较全的,更适合晋升为master
0
restore_as_passive_master() {
    verify_active_vip

    sudo systemctl stop ${EFM_SERVICE} && sudo systemctl start ${EFM_SERVICE}

    # enable archive always
    sudo sed -i "s/archive_mode = on/archive_mode = always/" ${PG_DATA}/postgresql.conf
    ${SUDO_EDB} ${PG_DATA}/gen_recovery_conf.sh  --nominal-master ${ACTIVE_VIP} passive_site

    sudo systemctl start ${PPAS_SERVICE}
    sudo ${EFM_BIN}/efm resume efm 2>&1 1>/dev/null
}

restore_as_active_master() {

    local DB_TYPE=$( local_db_type )
    if [[ ${DB_TYPE} != "Passive Master" ]]; then
        echo "Local DB type: ${DB_TYPE}"
        echo "[ERROR] Command need to be run on Passive Master" 1>&2
        return 1
    fi

    # enable archive always
    sudo sed -i "s/archive_mode = always/archive_mode = on/" ${PG_DATA}/postgresql.conf

    sudo systemctl restart ${PPAS_SERVICE}
    sudo ${EFM_BIN}/efm resume efm 2>&1 1>/dev/null
}
:<<0
# select application_name from pg_stat_replication limit 1;
 application_name 
------------------
 standby1
(1 row)

# select regexp_split_to_table(current_setting('synchronous_standby_names'),E',\\s+') as name except select application_name from pg_stat_replication limit 1;
   name   
----------
 standby2
0

:<<gen
gen_recovery_conf.sh --nominal-master 10.163.249.157 passive_site
standby_mode='on'
primary_conninfo='application_name=passive_site user=replication host=10.163.249.157 port=5432 sslmode=prefer sslcompression=1 krbsrvname=postgres'
trigger_file='/var/lib/ppas/9.5/data/trigger.file'
recovery_target_timeline='latest'
restore_command='rsync -a -e "ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null" enterprisedb@10.163.249.157:/mnt/edbwal/passive_site/%f %p || false'

gen_recovery_conf.sh  10.163.249.157 standby2
standby_mode='on'
primary_conninfo='application_name=standby2 user=replication host=10.163.249.157 port=5432 sslmode=prefer sslcompression=1 krbsrvname=postgres'
trigger_file='/var/lib/ppas/9.5/data/trigger.file'
recovery_target_timeline='latest'
restore_command='rsync -a /mnt/edbwal/standby2/%f %p || false'
gen

configure_as_standby() {
    if [[ -z ${1} ]]; then
        echo "MASTER_HOST is required" 1>&2
        return 1
    fi

    local APP_NAME
    local MASTER_IP=${1}

    local SELECT_AVAILABLE_APP_NAME="select regexp_split_to_table(current_setting('synchronous_standby_names'), E',\\\s+') as name except select application_name from pg_stat_replication limit 1;"
    APP_NAME=$(sql_exec ${MASTER_IP} "${SELECT_AVAILABLE_APP_NAME}")
    if [[ ${?} != 0 ]]; then
        echo "ERROR Unable to detect available APP_NAME" 1>&2
        return 1
    fi

    ${SUDO_EDB} ${PG_DATA}/gen_recovery_conf.sh ${MASTER_IP} ${APP_NAME}
    sudo sed -i "s/archive_mode = always/archive_mode = on/" ${PG_DATA}/postgresql.conf
}

reinit_as_standby() {
    if [[ -z ${1} ]]; then
        echo "MASTER_IP is required" 1>&2
        return 1
    fi

    local MASTER_IP=${1}

    clear_pg_data

    local PASSIVE_MASTER_IP=$( ${EFM_BIN}/efm cluster-status-json efm | python -c 'import sys, json; print json.load(sys.stdin)["failoverpriority"][0]' )

    # copy all from master
    copy_pg_data ${MASTER_IP}

    configure_as_standby ${MASTER_IP} || return $?

    sudo systemctl restart ${PPAS_SERVICE}
    sudo ${EFM_BIN}/efm resume efm
}
reinit_as_active_standby() {
    sudo systemctl stop ${EFM_SERVICE} && sudo systemctl start ${EFM_SERVICE}
    local MASTER_IP=$( ${EFM_BIN}/efm cluster-status-json efm | python -c 'import sys, json; print next((ip for ip, info in json.load(sys.stdin)["nodes"].iteritems() if info["type"] == "Master"))' )
    if [[ -z "${MASTER_IP}" ]]; then
        echo "Unable to detect master. Make sure master node is up and running." 1>&2
        return 1
    fi

    reinit_as_standby "${MASTER_IP}"
}
:<<09
passive_standby 就是从指从 passive_master 进行复制操作的slave
09
reinit_as_passive_standby() {
    verify_active_vip
    sudo systemctl stop ${EFM_SERVICE} && sudo systemctl start ${EFM_SERVICE}
    local PASSIVE_MASTER_IP=$( ${EFM_BIN}/efm cluster-status-json efm | python -c 'import sys, json; print json.load(sys.stdin)["failoverpriority"][0]' )
    if [[ -z "${PASSIVE_MASTER_IP}" ]]; then
        echo "Unable to detect passive master. Make sure passive master node is up and running." 1>&2
        return 1
    fi

    reinit_as_standby "${PASSIVE_MASTER_IP}"
}
monitor_xlogs_restore() {
    local XLOG=$( sql_exec localhost "select pg_last_xlog_replay_location();" )
    local XLOG_NEW
    for i in {1..30}; do
        if [[ $? == 0 ]]; then
            echo "XLog Loc: ${XLOG}"
        fi
        sleep 2;
        XLOG_NEW=$( sql_exec localhost "select pg_last_xlog_replay_location();" )
        if [[ x"${XLOG}" == x"${XLOG_NEW}" ]]; then
            break
        fi
        XLOG=${XLOG_NEW}
    done
}

restore_as_standby() {
    if [[ -z ${1} ]]; then
        echo "MASTER_IP is required" 1>&2
        return 1
    fi

    local MASTER_IP=${1}

    configure_as_standby ${MASTER_IP} || return $?

    sudo systemctl restart ${PPAS_SERVICE} && monitor_xlogs_restore && sudo systemctl stop ${PPAS_SERVICE}

    ${SUDO_EDB} ${PG_BIN}/pg_rewind -P -D ${PG_DATA} --source-server="port=${PG_PORT} host=${MASTER_IP} dbname=edb" || return $?
    configure_as_standby ${MASTER_IP} || return $?

    sudo systemctl restart ${PPAS_SERVICE} || return $?
    sudo ${EFM_BIN}/efm resume efm
}

restore_as_active_standby() {

    sudo systemctl stop ${EFM_SERVICE} && sudo systemctl start ${EFM_SERVICE} || return $?

    local MASTER_IP=$( ${EFM_BIN}/efm cluster-status-json efm | python -c 'import sys, json; print next((ip for ip, info in json.load(sys.stdin)["nodes"].iteritems() if info["type"] == "Master"))' )
    if [[ -z "${MASTER_IP}" ]]; then
        echo "Unable to detect master. Make sure master node is up and running." 1>&2
        return 1
    fi

    restore_as_standby ${MASTER_IP}
}

restore_as_passive_standby() {

    sudo systemctl stop ${EFM_SERVICE} && sudo systemctl start ${EFM_SERVICE} || return $?

    local PASSIVE_MASTER_IP=$( ${EFM_BIN}/efm cluster-status-json efm | python -c 'import sys, json; print json.load(sys.stdin)["failoverpriority"][0]' )
    if [[ -z "${PASSIVE_MASTER_IP}" ]]; then
        echo "Unable to detect passive master. Make sure passive master node is up and running." 1>&2
        return 1
    fi
    restore_as_standby ${PASSIVE_MASTER_IP}
}

local_db_type() {
    if [[ $( sql_exec localhost "SELECT pg_is_in_recovery();" ) == "f" ]]; then
        echo "Master"
    elif [[ $( sql_exec localhost "SELECT current_setting('archive_mode')='always';" ) == "t" ]]; then
        echo "Passive Master"
    else
        echo "Standby"
    fi
}

if_master_validation() {
    local MASTER_IP=$( cat ${PG_EDBWAL_MOUNT}/.masterip )
    if [[ ! ( $( ip addr show to ${MASTER_IP} ) || -f ${PG_DATA}/recovery.conf ) ]]; then
        echo "Appears to be old master, try to reconfigure as standby" 1>&2

        configure_as_standby ${MASTER_IP} || return $?
    fi
}
usage() {
    echo $"Usage:"
    echo $"       $0 local_db_type"
    echo $""
    echo $"       $0 prepare_passive_site_cluster"
    echo $"       $0 reinit_as_passive_master"
    echo $"       $0 restore_as_passive_master"
    echo $"       $0 restore_as_active_master"
    echo $""
    echo $"       $0 reinit_as_active_standby"
    echo $"       $0 reinit_as_passive_standby"
    echo $"       $0 restore_as_active_standby"
    echo $"       $0 restore_as_passive_standby"
    exit 1

}

if [ $# -eq 1 ]; then
    COMMAND=${1}
    case "${COMMAND}" in
        local_db_type)
            local_db_type
            exit $?
        ;;

        prepare_passive_site_cluster)
            prepare_passive_site_cluster
            exit $?
        ;;
        reinit_as_passive_master)
            reinit_as_passive_master
            exit $?
        ;;
        restore_as_passive_master)
            restore_as_passive_master
            exit $?
        ;;
        restore_as_active_master)
            restore_as_active_master
            exit $?
        ;;

        reinit_as_active_standby)
            reinit_as_active_standby
            exit $?
        ;;
        reinit_as_passive_standby)
            reinit_as_passive_standby
            exit $?
        ;;
        restore_as_active_standby)
            restore_as_active_standby
            exit $?
        ;;
        restore_as_passive_standby)
            restore_as_passive_standby
            exit $?
        ;;
        if_master_validation)
            if_master_validation
            exit $?
        ;;
        *)
            usage
    esac
else
    usage
fi
