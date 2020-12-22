#!/bin/sh
# Copyright EnterpriseDB Corporation, 2014-2017. All Rights Reserved.

# used as a key in the recovery.conf file header
EDB_FM="EDB Failover Manager"

# version name
EFM=efm-2.1

# declare this to avoid static analysis warnings due to use as outvars from getProps
DB_SERVICE_OWNER=

# needed in some functions below
if [ -f /etc/redhat-release ] ; then
    OS_VER=`grep '[0-9]\.[0-9]' -o /etc/redhat-release | awk 'BEGIN {FS="."} {print $1}'`
elif [ -f /etc/os-release ] ; then
    OS_VER=`grep VERSION_ID /etc/os-release|xargs echo|cut -d "=" -f2| awk 'BEGIN {FS="."} {print $1}'`
else
    echo 'Unsupported distro.'
    exit 1
fi
usage() {
    echo $"Usage: $0 validatedbowner         <cluster name>"
    echo $"       $0 writepidkey             <cluster name> <pid>"
    echo $"       $0 deletepidkey            <cluster name>"
    echo $"       $0 readnodes               <cluster name>"
    echo $"       $0 writenodes              <cluster name> <node information>"
    echo $"       $0 checkauthfileperms      <cluster name>"
    echo $"       $0 restartdbservice        <cluster name>"
    echo $"       $0 startdbservice          <cluster name>"
    echo $"       $0 stopdbservice           <cluster name>"
    echo $"       $0 dbservicestatus         <cluster name>"
    exit 1
}

#
# Test the properties file to make sure it is root owned with 644 perms
# before continuing.
#
checkPropsFilePerms() {
    OWNER=`stat -c %U ${1}`
    MODE=`stat -c %a ${1}`
    if [ "$OWNER" = "root" -a "$MODE" = "644" ]; then
        return 0;
    else
        return 1;
    fi
}

#
# Test the nodes file to make sure it is root owned with 600 perms
# before continuing.
#
checkNodesFilePerms() {
    NODESFILE="/etc/${EFM}/${1}.nodes"
    OWNER=`stat -c %U ${NODESFILE}`
    MODE=`stat -c %a ${NODESFILE}`
    if [ "$OWNER" = "root" -a "$MODE" = "600" ]; then
        return 0;
    else
        return 1;
    fi
}

#
# look for the last occurrence of a non-commented line
#
# shell functions can't return string, so rely on clunky outvar
#
# Params
#   $1 outvar - this is the name of the variable to store the result in
#   $2 property name to look for
#   $3 property file to grep in
getProp() {
    local OUTVAR=$1
    local PROP_NAME=$2
    local PROP_FILE=$3
    local RESULT=`grep ${PROP_NAME} ${PROP_FILE} | grep -v \# | tail -1 | cut -d'=' -f2`
    eval ${OUTVAR}=\$RESULT
}

#
# This function requires root privs
#
# write a PID file and auth key in /var/run
#
writePidKey() {
    echo $2 > /var/run/${1}.pid
    tr -dc A-Za-z0-9 </dev/urandom | head -c 64 > /var/run/${1}.key
    chmod 640 /var/run/${1}.key
    chown efm:efm /var/run/${1}.key
}

#
# This function requires root privs
#
# delete a PID file and auth key in /var/run
#
deletePidKey() {
    rm -f /var/run/${1}.pid
    rm -f /var/run/${1}.key
}

#
# Test the nodes file to make sure it is root owned with 600 perms
# before continuing.
#
checkauthfileperms() {
    local AUTH_FILE="/var/run/${EFM}.${1}.key"
    OWNER=`stat -c %U ${AUTH_FILE}`
    MODE=`stat -c %a ${AUTH_FILE}`
    if [ "$OWNER" = "efm" -a "$MODE" = "640" ]; then
        return 0;
    else
        return 1;
    fi
}

#
# This function requires root privs
#
# Validate that the db.service.owner property specified by the user:
#    1. exists
#    2. matches what's in sudoers.d/efm-20
#
validateDbOwner() {
    local PROP_FILE=$1
    getProp DB_SERVICE_OWNER db.service.owner ${PROP_FILE}
    id -u ${DB_SERVICE_OWNER} &> /dev/null
    if [ $? -eq 0 ]; then
        grep \(${DB_SERVICE_OWNER}\) /etc/sudoers.d/* 2>&1 > /dev/null
        if [ $? -eq 0 ]; then
            return 0;
        else
            echo "ERROR: user ${DB_SERVICE_OWNER} is not granted sufficient privileges in /etc/sudoers.d/efm-20"
            return 1;
        fi
    else
        echo "ERROR: ${DB_SERVICE_OWNER} is not a user on this system"
        return 1
    fi
}

#
# restart database
# 重启数据库
restartdbservice() {
    local PROP_FILE=$1
    # 从配置文件中获取配置的service name
    getProp SERVICE_NAME db.service.name ${PROP_FILE}
    if [ -z "$SERVICE_NAME" ]; then
        # some kind of error grepping the service name from the prop file
        echo 'Cannot find db.service.name value.'
        return 1
    else
        if [ "$OS_VER" -eq 6 ]; then
            service ${SERVICE_NAME} restart
        else
            # 这里调用服务管理工具来 进行重启
            systemctl restart ${SERVICE_NAME}
        fi
    fi
}

#
# start database
#
startdbservice() {
    local PROP_FILE=$1
    getProp SERVICE_NAME db.service.name ${PROP_FILE}
    if [ -z "$SERVICE_NAME" ]; then
        # some kind of error grepping the service name from the prop file
        echo 'Cannot find db.service.name value.'
        return 1
    else
        if [ "$OS_VER" -eq 6 ]; then
            service ${SERVICE_NAME} start
        else
            systemctl start ${SERVICE_NAME}
        fi
    fi
}

#
# stop database
#
stopdbservice() {
    local PROP_FILE=$1
    getProp SERVICE_NAME db.service.name ${PROP_FILE}
    if [ -z "$SERVICE_NAME" ]; then
        # some kind of error grepping the service name from the prop file
        echo 'Cannot find db.service.name value.'
        return 1
    else
        if [ "$OS_VER" -eq 6 ]; then
            service ${SERVICE_NAME} stop
        else
            systemctl stop ${SERVICE_NAME}
        fi
    fi
}

#
# get database service status (used to help catch typos in service name property
#
dbservicestatus() {
    local PROP_FILE=$1
    getProp SERVICE_NAME db.service.name ${PROP_FILE}
    if [ -z "$SERVICE_NAME" ]; then
        # some kind of error grepping the service name from the prop file
        echo 'Cannot find db.service.name value.'
        return 1
    else
        if [ "$OS_VER" -eq 6 ]; then
            service ${SERVICE_NAME} status
        else
            systemctl status ${SERVICE_NAME}
        fi
    fi
}

readnodes() {
    NODESFILE="/etc/${EFM}/${1}.nodes"
    cat ${NODESFILE}
}

writenodes() {
    NODESFILE="/etc/${EFM}/${1}.nodes"
    CONTENTS=$2
    echo "# List of node address:port combinations separated by whitespace." > ${NODESFILE}
    echo "# The list should include at least the membership coordinator's address." >> ${NODESFILE}
    echo ${CONTENTS} >> ${NODESFILE}
}
#
# process the command
#
# command names correlate to enum values in SudoFunctions.java. If you add new functions
# here, then also add a value in SudoFunctions...
#
if [ $# -gt 1 ]; then
    COMMAND=$1
    case "$COMMAND" in
        writepidkey)
            if [ $# -eq 3 ]; then
                NAME="${EFM}.${2}"
                PID=$3
                writePidKey ${NAME} ${PID}
                exit $?
            else
                usage
            fi
            ;;
        deletepidkey)
            if [ $# -eq 2 ]; then
                NAME="${EFM}.${2}"
                deletePidKey ${NAME}
                exit $?
            else
                usage
            fi
            ;;
        readnodes)
            CLUSTERNAME=$2
            if checkNodesFilePerms ${CLUSTERNAME}; then
                readnodes ${CLUSTERNAME}
                exit $?
            else
                echo "Permission denied. /etc/${EFM}/${CLUSTERNAME}.nodes must be owned by root with 600 permissions."
                exit 1
            fi
            ;;
        writenodes)
            NODEFILE=$2
            shift 2
            NODES=$*
            writenodes ${NODEFILE} "${NODES}"
            exit $?
            ;;
        checkauthfileperms)
                CLUSTERNAME=$2
                checkauthfileperms ${CLUSTERNAME}
                exit $?
                ;;
    esac
    PROPS="/etc/${EFM}/$2.properties"
    if checkPropsFilePerms ${PROPS}; then
        case "$COMMAND" in
            validatedbowner)
                validateDbOwner ${PROPS}
                exit $?
                ;;
            restartdbservice)
                restartdbservice ${PROPS}
                exit $?
                ;;
            startdbservice)
                startdbservice ${PROPS}
                exit $?
                ;;
            stopdbservice)
                stopdbservice ${PROPS}
                exit $?
                ;;
            dbservicestatus)
                dbservicestatus ${PROPS}
                exit $?
                ;;
            *)
                usage
        esac
    else
        echo "Permission denied. ${PROPS} must be owned by root with 644 permissions."
        exit 1
    fi
else
    usage
fi
