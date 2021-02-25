#!/bin/bash
BASE=$(cd $(dirname $0); pwd)
sourceIds=[]
BASEDIR="collect"

createEms(){
    # get names
    names=$(cat ${BASE}/ems |awk '{print $9}'| sed -r 's#(GD-PM-)([A-Z]{3,5}-)(A001-)(V[0-9.]{5}-)([0-9]{14})(-[0-9]{2}.xml)#\1\2\3\4time\6#p')
    #echo "names $names"
    python3 ${BASE}/pp.py ems ems001 ${startTime} ${endTime} ${BASEDIR} ${names}
}

createVim(){
    names=$(cat ${BASE}/vim | awk '{split($9, arr, "@"); print arr[2]}' | sed -rn 's#(.*)#@\1#p')
    echo "names : $names"
    python3 ${BASE}/pp.py vim vim001 ${startTime} ${endTime} ${BASEDIR} ${names}
}

createPim(){
    python3 ${BASE}/pp.py pim pim001 ${startTime} ${endTime} ${BASEDIR} 
}

usage(){
    echo "$0 type[ems,vim,pim]  stime endtime[format:2021-02-2400:00:00]"
    exit 
}

main(){
    echo $#
    if [ !"$#" -eq 3 ]; then
        usage
    fi
    type=$1
    #startTime="2021-02-2400:00:00"
    #endTime="2021-02-2600:00:00"
    startTime=$2
    endTime=$3

    case $type in
    "vim")
        createVim
        ;;
    "pim")
        createPim
        ;;
    "ems")
        createEms
        ;;
    *)
        usage
        ;;
    esac
}

main $@
