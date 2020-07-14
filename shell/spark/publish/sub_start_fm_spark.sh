#!/bin/bash
CBASE=$(cd $(dirname $0); pwd)
. ${CBASE}/env.sh > /dev/null 2>&1
if [ $# -ne 1 ];then
    usage
    exit 1
fi

case $1 in
1|$FMStandard)
${CBASE}/start_fm_standard.sh
;;
2|$FMAMS)
${CBASE}/start_fm_master_slave.sh
;;
3|$FMADC)
${CBASE}/start_fm_derivation.sh
;;
all)
${CBASE}/start_fm_standard.sh
${CBASE}/start_fm_master_slave.sh
${CBASE}/start_fm_derivation.sh
;;
*)
usage
exit 1
;;
esac