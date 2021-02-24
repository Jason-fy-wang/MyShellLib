#!/bin/bash
BASE=$(cd $(dirname $0); pwd)
sourceIds=[]
BASEDIR="collect"

createEms(){
    # get names
    names=$(cat ${BASE}/ems |awk '{print $9}'| sed -r 's#(GD-PM-)([A-Z]{3,5}-)(A001-)(V[0-9.]{5}-)([0-9]{14})(-[0-9]{2}.xml)#\1\2\3\4time\6#p')
    echo "names $names"
    startTime="2021-02-2415:00:00"
    endTime="2021-02-2515:00:00"
    python3 ${BASE}/pp.py ems ems001 ${startTime} ${endTime} ${BASEDIR} ${names}
}

createVim(){
    names=$(cat ${BASE}/vim | awk '{split($9, arr, "@"); print arr[2]}' | sed -rn 's#(.*)#@\1#p')
    startTime="2021-02-2415:00:00"
    endTime="2021-02-2515:00:00"
    python3 ${BASE}/pp.py vim vim001 ${startTime} ${endTime} ${BASEDIR} ${names}
}

createPim(){
    startTime="2021-02-2415:00:00"
    endTime="2021-02-2515:00:00"
    python3 ${BASE}/pp.py pim pim001 ${startTime} ${endTime} ${BASEDIR} 
}
createPim

#createEms



