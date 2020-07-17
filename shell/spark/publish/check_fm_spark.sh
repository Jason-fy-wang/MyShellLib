#!/bin/bash
CBASE=$(cd $(dirname $0); pwd)
. ${CBASE}/env.sh > /dev/null 2>&1

lenp=${#Apps[@]}
let llp=${lenp}-1

for ii in $(seq 0 ${llp})
do
    ccc=0
    for dd in $(seq 0 $len1)
    do
        if [ "${Apps[$ii]}" == "${drivers[$dd]}" ]; then
            break
        else
            let ccc++
        fi
    done
    if [ "$ccc" -eq "$len" ]; then
        echo "somethine error in ${Apps[$ii]}"
    else
        echo "${Apps[$ii]} is ok.."
    fi
done