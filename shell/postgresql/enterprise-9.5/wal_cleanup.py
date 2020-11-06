#!/usr/bin/env python

import sys
import re
import psycopg2
import subprocess
import os
import time

EDB_PORT = "5432"
EDB_WAL_BASE_DIR = "/mnt/edbwal"
EDB_BIN_DIR = "/usr/ppas-9.5/bin"
EDB_DATA_DIR = "/var/lib/ppas/9.5/data"

EDB_HOST_LOCAL = "localhost"
EDB_HOST_VIP = "rdb_vip"
APP_NAMES = ["standby1", "standby2", "passive_site"]


def clean_old_wal_files(days_old=7):
    current_time = time.time()
    for app_name in APP_NAMES:
        path = os.path.join(EDB_WAL_BASE_DIR, app_name)
        for f in os.listdir(path):
            f = os.path.join(path, f)
            creation_time = os.path.getmtime(f)
            if (current_time - creation_time) / (24 * 3600) >= days_old and os.path.exists(f):
                os.remove(f)


def main():

    conn_local = psycopg2.connect("dbname=edb host={0} port={1}".format(EDB_HOST_LOCAL, EDB_PORT))
    cur_local = conn_local.cursor()

    try:
        cur_local.execute("SELECT pg_is_in_recovery()")
        if not cur_local.fetchone()[0]:
            clean_old_wal_files(2)
            return

        cur_local.execute("SELECT pg_last_xlog_replay_location()")
        xlog_location = cur_local.fetchone()
    finally:
        cur_local.close()
        conn_local.close()

    conn_vip = psycopg2.connect("dbname=edb host={0} port={1}".format(EDB_HOST_VIP, EDB_PORT))
    cur_vip = conn_vip.cursor()
    try:
        cur_vip.execute("SELECT pg_xlogfile_name(%s)", xlog_location)
        xloqfile_name = cur_vip.fetchone()[0]
    finally:
        cur_vip.close()
        conn_vip.close()

    app_name = ""
    with open("{0}/recovery.conf".format(EDB_DATA_DIR)) as recovery_file:
        for line in recovery_file:
            if not "primary_conninfo" in line:
                continue
            app_name = re.search(r'application_name=([^\s]*)', line).group(1)
            break

    clean_up = subprocess.Popen([("{0}/pg_archivecleanup".format(EDB_BIN_DIR)),
                                 "{0}/{1}".format(EDB_WAL_BASE_DIR, app_name), xloqfile_name])
    clean_up.wait()
    sys.exit(clean_up.returncode)


if __name__ == '__main__':
    main()
