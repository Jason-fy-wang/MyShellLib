#!/bin/sh
# Copyright EnterpriseDB Corporation, 2014-2017. All Rights Reserved.

# used as a key in the recovery.conf file header
EDB_FM="EDB Failover Manager"

# version name
EFM=efm-2.1

# declare these to avoid static analysis warnings due to use as outvars from getProps
TRIGGER_FILE=
RECOVERY_CONF_DIR=

usage() {
    echo $"Usage: $0 writetriggerfile        <cluster name>"
    echo $"       $0 readtriggerlocation     <cluster name>"
    echo $"       $0 writerecoveryconf       <cluster name>"
    echo $"       $0 writecustomrecoveryconf <cluster name> <contents>"
    echo $"       $0 removerecoveryconf      <cluster name>"
    echo $"       $0 validaterecoveryconf    <cluster name>"
    echo $"       $0 validatepgbin           <cluster name>"
    echo $"       $0 recoveryconfexists      <cluster name>"
    echo $"       $0 changemasterhost        <cluster name> <host>"
    echo $"       $0 restartdb               <cluster name>"
    echo $"       $0 startdb                 <cluster name>"
    echo $"       $0 stopdb                  <cluster name>"
    echo $"       $0 readrecoveryconf        <cluster name>"
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
# touch the trigger file
# this function also tests if the trigger file exists before writing
#
writeTriggerFile() {
    local PROP_FILE=$1
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    if [ -z "$RECOVERY_CONF_DIR" ]; then
        # some kind of error grepping the recovery.conf location from the prop file
        return 1
    else
        getProp QUOTED_TRIGGER_FILE trigger_file ${RECOVERY_CONF_DIR}/recovery.conf

        # remove single quotes around value
        TRIGGER_FILE=$(echo $QUOTED_TRIGGER_FILE | xargs echo)
        if [ -z "$TRIGGER_FILE" ]; then
            # some kind of error grepping the trigger file from the prop file
            echo "ERROR: Unable to read db.trigger.file property"
            return 1
        elif [ -e "$TRIGGER_FILE" ]; then
            echo "ERROR: Trigger file already exists. Could not promote standby."
            return 1
        else
            touch ${TRIGGER_FILE}
            return $?
        fi
    fi
}

#
# read the trigger file location from the recovery.conf file
#
readtriggerlocation() {
    local PROP_FILE=$1
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    if [ -z "$RECOVERY_CONF_DIR" ]; then
        # some kind of error grepping the recovery.conf location from the prop file
        return 1
    else
        local RECOVERY_CONF="${RECOVERY_CONF_DIR}/recovery.conf"
        if [ -e "${RECOVERY_CONF}" ]; then
            getProp TRIGGER_FILE trigger_file ${RECOVERY_CONF}
            echo $TRIGGER_FILE
        else
            echo "ERROR: cannot find file ${RECOVERY_CONF}."
            return 1
        fi
    fi
}

#
# read the recovery.conf file. this is needed during switchover to save on original master
#
readrecoveryconf() {
    local PROP_FILE=$1
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    if [ -z "$RECOVERY_CONF_DIR" ]; then
        # some kind of error grepping the recovery.conf location from the prop file
        return 1
    else
        local RECOVERY_CONF="${RECOVERY_CONF_DIR}/recovery.conf"
        if [ -e "${RECOVERY_CONF}" ]; then
            cat ${RECOVERY_CONF}
        else
            echo "ERROR: cannot find file ${RECOVERY_CONF}."
            return 1
        fi
    fi
}

#
# will replace the host=foo information in recovery.conf file with
# new host information.
#
changemasterhost() {
    local PROP_FILE=$1
    local NEW_HOST=$2
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    if [ -z "$RECOVERY_CONF_DIR" ]; then
        # some kind of error grepping the recovery.conf location from the prop file
        return 1
    else
        local RECOVERY_CONF=${RECOVERY_CONF_DIR}/recovery.conf
        if [ -e "$RECOVERY_CONF" ]; then
            cp ${RECOVERY_CONF} ${RECOVERY_CONF}_$(date +%F-%T)
            sed -i s/host\ *=\ *[^\'\ ]*/host=${NEW_HOST}/i ${RECOVERY_CONF}
            return $?
        else
            echo "could not find file ${RECOVERY_CONF}"
            return 1
        fi
    fi
}

#
# restart database
# 重启数据库
restartdb() {
    local PROP_FILE=$1
    # 从配置文件获取 bin目录  recovery.conf的目录  timeout
    getProp PG_CTL_PATH db.bin ${PROP_FILE}
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    getProp TIMEOUT local.timeout ${PROP_FILE}
    if [ -z "$RECOVERY_CONF_DIR" ]; then
        # some kind of error grepping the recovery.conf location from the prop file
        return 1
    else
        ${PG_CTL_PATH}/pg_ctl restart -m fast -w -t ${TIMEOUT} -D ${RECOVERY_CONF_DIR}
    fi
}

#
# start database
#
startdb() {
    local PROP_FILE=$1
    getProp PG_CTL_PATH db.bin ${PROP_FILE}
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    getProp TIMEOUT local.timeout ${PROP_FILE}
    if [ -z "$RECOVERY_CONF_DIR" ]; then
        # some kind of error grepping the recovery.conf location from the prop file
        return 1
    else
        ${PG_CTL_PATH}/pg_ctl start -w -D ${RECOVERY_CONF_DIR}
    fi
}

#
# stop database
#
stopdb() {
    local PROP_FILE=$1
    getProp PG_CTL_PATH db.bin ${PROP_FILE}
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    getProp TIMEOUT local.timeout ${PROP_FILE}
    if [ -z "$RECOVERY_CONF_DIR" ]; then
        # some kind of error grepping the recovery.conf location from the prop file
        return 1
    else
        ${PG_CTL_PATH}/pg_ctl stop -m fast -D ${RECOVERY_CONF_DIR}
    fi
}

#
# validate the recovery conf property
# return success if:
#    recovery.conf dir exists and is writable
#    recovery.conf dir is a dir
#
# Environment.java has already verified that the property is set in the prop file
#
# Note: this function no longer checks to see if the recovery.conf file actually exists
#       because we are now asking the db if it is in recovery mode or not at startup to
#       assign master/standby roles.
#
validateRecoveryConf() {
    local PROP_FILE=$1
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    if [ -z "$RECOVERY_CONF_DIR" ]; then
        # some kind of error grepping the recovery.conf location from the prop file
        return 1
    else
        if [ -w "$RECOVERY_CONF_DIR" ] && [ -d "$RECOVERY_CONF_DIR" ]; then
             return 0
        else
            echo "ERROR: db.recovery.conf.dir must exist, be a directory, and be writable: $RECOVERY_CONF_DIR"
            return 1
        fi
    fi
}

#
#
#
validatepgbin() {
    local PROP_FILE=$1
    getProp BIN_DIR db.bin ${PROP_FILE}
    if [ -z "$BIN_DIR" ]; then
        # some kind of error grepping the db.bin location from the prop file
        return 1
    else
        if [ -x "$BIN_DIR/pg_ctl" ]; then
             return 0
        else
            echo "ERROR: db.bin must exist, be a directory, and contain pg_ctl: $BIN_DIR"
            return 1
        fi
    fi
}

#
# write the recovery.conf file
#
writeRecoveryConfFile() {
    local PROP_FILE=$1
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    if [ -z "$RECOVERY_CONF_DIR" ]; then
        # some kind of error grepping the recovery.conf location from the prop file
        return 1
    elif [ -e ${RECOVERY_CONF_DIR}/recovery.conf ]; then
        grep "$EDB_FM" ${RECOVERY_CONF_DIR}/recovery.conf 2>&1 > /dev/null
        if [ $? -eq 0 ]; then
            # file exists, but it's ours, so delete it and re-write it (below)
            rm -f ${RECOVERY_CONF_DIR}/recovery.conf
        else
            # file exists and it's not ours, so rename it and write ours (below)
            mv ${RECOVERY_CONF_DIR}/recovery.conf ${RECOVERY_CONF_DIR}/recovery.conf.`date +%Y-%m-%d_%H:%M`
        fi
    fi
    cat > ${RECOVERY_CONF_DIR}/recovery.conf << EOF
# $EDB_FM
# This generated recovery.conf file prevents the db server from accidentally
# being restarted as a master since a failover or promotion has occurred
standby_mode = on
restore_command = 'echo 2>"recovery suspended on failed server node"; exit 1'
EOF
    return $?
}

#
# write custom recovery.conf file
#
writeCustomRecoveryConf() {
    local PROP_FILE=$1
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    if [ -z "$RECOVERY_CONF_DIR" ]; then
        # some kind of error grepping the recovery.conf location from the prop file
        return 1
    elif [ -e ${RECOVERY_CONF_DIR}/recovery.conf ]; then
        # file exists, so rename it and write ours (below)
        mv ${RECOVERY_CONF_DIR}/recovery.conf ${RECOVERY_CONF_DIR}/recovery.conf.`date +%Y-%m-%d_%H:%M`
    fi
    echo -e $2 > ${RECOVERY_CONF_DIR}/recovery.conf
    return $?
}

#
# remove recovery.conf file
#
removerecoveryconf() {
    local PROP_FILE=$1
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    if [ -z "$RECOVERY_CONF_DIR" ]; then
        # some kind of error grepping the recovery.conf location from the prop file
        return 1
    fi
    rm -f ${RECOVERY_CONF_DIR}/recovery.conf
    return $?
}
#
# test if a recovery.conf file exists that wasn't created by EFM. We don't really
# care if we find a recovery.conf file created by EFM
#
recoveryConfExists() {
    local PROP_FILE=$1
    getProp RECOVERY_CONF_DIR db.recovery.conf.dir ${PROP_FILE}
    # Note: we aren't testing for -z $RECOVERY_CONF_DIR here because the prop should
    #       have already been validated with validateRecoveryConf().
    if [ -e ${RECOVERY_CONF_DIR}/recovery.conf ]; then
        grep "$EDB_FM" ${RECOVERY_CONF_DIR}/recovery.conf 2>&1 > /dev/null
        if [ $? -eq 0 ]; then
            # file exists, but it's ours, so delete it and return false
            rm -f ${RECOVERY_CONF_DIR}/recovery.conf
            return 1
        else
            # file exists and it's not ours, so return true
            return 0
        fi
    else
        # file doesn't exist
        return 1
    fi
}

#
# process the command
#
# command names correlate to enum values in SudoFunctions.java. If you add new functions
# here, then also add a value in SudoFunctions...
#
if [ $# -gt 1 ]; then
# $1 命令   $2 clustername  $3 其他参数,如:new host
    COMMAND=$1
    PROPS="/etc/${EFM}/$2.properties"
    if checkPropsFilePerms ${PROPS}; then
        case "$COMMAND" in
            writetriggerfile)
                writeTriggerFile ${PROPS}
                exit $?
                ;;
            readtriggerlocation)
                readtriggerlocation ${PROPS}
                exit $?
                ;;
            readrecoveryconf)
                readrecoveryconf ${PROPS}
                exit $?
                ;;
            validaterecoveryconf)
                validateRecoveryConf ${PROPS}
                exit $?
                ;;
            validatepgbin)
                validatepgbin ${PROPS}
                exit $?
                ;;
            writerecoveryconf)
                writeRecoveryConfFile ${PROPS}
                exit $?
                ;;
            removerecoveryconf)
                removerecoveryconf ${PROPS}
                exit $?
                ;;
            writecustomrecoveryconf)
                shift
                shift
                TEXT=$*
                writeCustomRecoveryConf ${PROPS} "${TEXT}"
                exit $?
                ;;
            recoveryconfexists)
                recoveryConfExists ${PROPS}
                exit $?
                ;;
            changemasterhost)
                changemasterhost ${PROPS} $3
                exit $?
                ;;
            restartdb)
                restartdb ${PROPS}
                exit $?
                ;;
            startdb)
                startdb ${PROPS}
                exit $?
                ;;
            stopdb)
                stopdb ${PROPS}
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
