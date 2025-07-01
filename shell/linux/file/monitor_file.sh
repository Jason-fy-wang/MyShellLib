#!/usr/bin/env bash
# sudo apt install auditd
# type=SYSCALL msg=audit(1751343065.476:234): arch=c000003e syscall=192 success=no exit=-61 a0=7fffb89a15b0 a1=740a126a4197 a2=5bd6bab79c30 a3=ff items=1 ppid=5440 pid=12353 auid=1000 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=pts6 ses=12 comm="ls" exe="/usr/bin/ls" subj=unconfined key="watch_file_test_txt"ARCH=x86_64 SYSCALL=lgetxattr AUID="scott" UID="scott" GID="scott" EUID="scott" SUID="scott" FSUID="scott" EGID="scott" SGID="scott" FSGID="scott"

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <file_to_monitor>"
  exit 1
fi

TARGET_FILE="$1"

if [ ! -e  "$TARGET_FILE" ]; then
  echo "File '$TARGET_FILE' does not exist."
  exit 1
fi

# run with root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

AUDIT_KEY="watch_file_$$"

function cleanup(){
    # Remove the audit rule
    auditctl -W "$TARGET_FILE" || true
    echo "Audit rule removed."
    exit
}

trap cleanup SIGINT SIGTERM

echo "adding audit rule on $TARGET_FILE (key=$AUDIT_KEY)"

auditctl -w "$TARGET_FILE" -p rxwa -k "$AUDIT_KEY"

echo "Monitoring I/O file: $TARGET_FILE"
echo "Press Ctrl+C to stop monitoring."


tail -n0 -F /var/log/audit/audit.log | grep --line-buffered "watch_file"| while read -r line; do
    pid=$(echo "$line" | grep -owP 'pid=\K\d+')
    comm=$(echo "$line" | grep -oP 'comm="\K[^"]+')
    exe=$(echo "$line" | grep -oP 'exe="\K[^"]+')
    syscall=$(echo "$line" | grep -oP 'syscall=\K[0-9]+' || echo '?')
    success=$(echo "$line" | grep -oP 'success=\K[^ ]+')

    # syscall name
    #sysname=$(ausearch --format raw <<< "$line" | egrep '^syscall' | head -1 | cut -d ' ' -f2-)
    timestamp=$(echo "$line" | grep -oP 'msg=audit\(\K[^:)]+')

    printf "Time: %s, PID: %s, Command: %s, Executable: %s, Syscall: %s, Success: %s\n" "$timestamp" "$pid" "$comm" "$exe" "$syscall" "$success"
done 




