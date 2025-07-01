#!/usr/bin/env bash

# usage: get_process_file_cache.sh <pid>

if [ -z "$1" ]; then
  echo "Usage: $0 <pid>"
  exit 1
fi

PID=$1
command -v fincore > /dev/null 2>&1
if [[ $? -ne "0"  ]]; then
  echo "fincore command not found. Please install it first."
  exit 1
fi

# get all opened regular files
files=()
for fd in /proc/$PID/fd/*; do
  file=$(readlink -f "$fd" 2>/dev/null) || continue
  if [[ -f $file ]]; then
    files+=("$file")
  fi
done

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No regular files found for PID $PID."
  exit 0
fi

# price cache usage
sudo fincore "${files[@]}"

