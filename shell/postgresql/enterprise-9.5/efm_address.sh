#!/bin/sh
# Copyright EnterpriseDB Corporation, 2013-2017. All Rights Reserved.

usage() {
    echo $"Usage: $0 assign  <interface name> <IPv4 address> <netmask>"
    echo $"       $0 release <interface name>"
    echo $"       $0 assign6  <interface name> <IPv6 address> <prefix length>"
    echo $"       $0 release6 <interface name> <IPv6 address> <prefix length>"
    exit 1
}

#
# add the VIP address to the interface
#
assign() {
    /sbin/ifconfig ${1} ${2} netmask ${3} up
    if [ $? -ne 0 ]; then
        return 1
    else
        # split interface name on the ':'
        intf=${1}
        intfArry=(${intf//:/ })

        /sbin/arping -q -c 3 -A -I ${intfArry[0]} ${2}
        return $?
    fi
}

#
# release the VIP address from the interface
#
release() {
    /sbin/ifconfig ${1} down
    return $?
}

#
# add the IPv6 VIP address to the interface
#
assign6() {
    /sbin/ip -6 addr add ${2}/${3} dev ${1}
    return $?
}

#
# release the IPv6 VIP address from the interface
#
release6() {
    /sbin/ip -6 addr del ${2}/${3} dev ${1}
    return $?
}

# make sure we at least have the assign/release command
if [ $# -lt 1 ]; then
    usage
fi

command=$1
shift

case "$command" in
  assign)
        if [ $# -eq 3 ]; then
            assign $@
            exit $?
        else
            usage
        fi
        ;;
  release)
        if [ $# -eq 1 ]; then
            release ${1}
            exit $?
        else
            usage
        fi
        ;;
  assign6)
        if [ $# -eq 3 ]; then
            assign6 $@
            exit $?
        else
            usage
        fi
        ;;
  release6)
        if [ $# -eq 3 ]; then
            release6 $@
            exit $?
        else
            usage
        fi
        ;;
  *)
        usage
esac
