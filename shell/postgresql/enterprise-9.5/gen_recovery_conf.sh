#!/usr/bin/env bash

PROGNAME=$0

NOMINAL=false

SHORTOPTS="h"
LONGOPTS="nominal-master"

# Execute getopt on the arguments passed to this program, identified by the special character $@
PARSED_OPTIONS=$(getopt -s bash --options $SHORTOPTS --longoptions $LONGOPTS --name $PROGNAME -- "$@" )

eval set -- "$PARSED_OPTIONS"

while true;
do
  case $1 in

    --nominal-master)
        NOMINAL="true"
        shift
        ;;
    --)
      shift
      break
      ;;

    --*)
      echo "Undefined option: $1"
      let SHIFT+=1
      exit 1
      ;;
    -?)
      echo "Undefined option: $1"
      let SHIFT+=1
      exit 1
      ;;
  esac
done

#Bad arguments, something has gone wrong with the getopt command.
if [ $? -ne 0 ]; then
    echo "[Usage]: ${PROGNAME} [--nominal-master] PG_HOST [PG_APP_NAME]" 1>&2
    exit 1
fi

PG_HOST=${1}
PG_APP_NAME=${2}

PG_DATA_DIR=/var/lib/ppas/9.5/data
PG_PORT=5432
PG_WAL_ARC_DIR=/mnt/edbwal

if [ "${NOMINAL}" == "false" ]; then
    PG_RESTORE_COMMAND="rsync -a ${PG_WAL_ARC_DIR}/${PG_APP_NAME}/%f %p || false"
else
    PG_RESTORE_COMMAND="rsync -a -e \"ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null\" enterprisedb@${PG_HOST}:${PG_WAL_ARC_DIR}/passive_site/%f %p || false"
fi

cat > $PG_DATA_DIR/recovery.conf <<-EOF
standby_mode='on'
primary_conninfo='application_name=${PG_APP_NAME} user=replication host=${PG_HOST} port=${PG_PORT} sslmode=prefer sslcompression=1 krbsrvname=postgres'
trigger_file='${PG_DATA_DIR}/trigger.file'
recovery_target_timeline='latest'
restore_command='${PG_RESTORE_COMMAND}'
EOF

chown enterprisedb:enterprisedb ${PG_DATA_DIR}/recovery.conf
