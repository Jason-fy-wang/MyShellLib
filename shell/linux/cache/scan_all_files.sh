#!/usr/bin/env bash

# this script need run with root

for pid in /proc/[0-9]*; do
  if [[ -d $pid ]]; then
    ## or can get id:  ${pid##*/}
    pid_num=$(basename "$pid")
    echo "Scanning PID: $pid_num"
    ./get_process_file_cache.sh "$pid_num"
  fi
done



