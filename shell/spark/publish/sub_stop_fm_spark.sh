#!/bin/bash
CBASE=$(cd $(dirname $0); pwd)
. ${CBASE}/env.sh > /dev/null 2>&1

if [ $# -ne 1 ];then
    usage
    exit 1
fi

case $1 in
1)
stopAS $FMStandard
;;
2)
stopAS $FMAMS
;;
3)
stopAS $FMADC
;;
all)
stopDriver
;;
*)
usage
exit 1
;;
esac