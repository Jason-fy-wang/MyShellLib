#!/bin/sh

# efm service name
EFM=efm-2.1

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
    echo $"Usage: $0 releasevip            <cluster name>"
    echo $"       $0 restartefmservice"
    echo $"       $0 startefmservice"
    echo $"       $0 stopefmservice"
    echo $"       $0 efmservicestatus"
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
#
getProp() {
    local OUTVAR=$1
    local PROP_NAME=$2
    local PROP_FILE=$3
    local RESULT=`grep ${PROP_NAME} ${PROP_FILE} | grep -v \# | tail -1 | cut -d'=' -f2`
    eval ${OUTVAR}=\$RESULT
}

#
# release virtualIp from interface defined in properties file
#
# Params
#   $1 prop_file - properties file name
#
releasevip() {
    local PROP_FILE=$1
    getProp VIP_INTF virtualIp.interface ${PROP_FILE}
    if [ -z "$VIP_INTF" ]; then
        # some kind of error grepping the service name from the prop file
        echo 'Cannot find virtualIp.interface value.'
        return 1
    else
        /usr/${EFM}/bin/efm_address release ${VIP_INTF}
        return $?
    fi
}

#
# restart efm service
#
restartefmservice() {
    if [ "$OS_VER" -eq 6 ]; then
        service ${EFM} restart
    else
        systemctl restart ${EFM}
    fi
}

#
# start efm service
#
startefmservice() {
    if [ "$OS_VER" -eq 6 ]; then
        service ${EFM} start
    else
        systemctl start ${EFM}
    fi
}

#
# stop efm service
#
stopefmservice() {

    if [ "$OS_VER" -eq 6 ]; then
        service ${EFM} stop
    else
        systemctl stop ${EFM}
    fi
}

#
# get efm service status
#
efmservicestatus() {

    if [ "$OS_VER" -eq 6 ]; then
        service ${EFM} status
    else
        systemctl status ${EFM}
    fi
}

#
# process the command
#
if [ $# -eq 2 ]; then
    COMMAND=$1
    PROPS="/etc/${EFM}/$2.properties"
    if checkPropsFilePerms ${PROPS}; then
        case "$COMMAND" in
            releasevip)
                releasevip ${PROPS}
                exit $?
                ;;
            *)
                usage
        esac
    else
        echo "Permission denied. ${PROPS} must be owned by root with 644 permissions."
        exit 1
    fi
elif [ $# -eq 1 ]; then
    COMMAND=$1
    case "$COMMAND" in
        restartefmservice)
            restartefmservice
            exit $?
            ;;
        startefmservice)
            startefmservice
            exit $?
            ;;
        stopefmservice)
            stopefmservice
            exit $?
            ;;
        efmservicestatus)
            efmservicestatus
            exit $?
            ;;
        *)
            usage
    esac
else
    usage
fi
