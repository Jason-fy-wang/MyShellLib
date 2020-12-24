#!/bin/bash
# Set INITDBOPTS environment variable to pass specific options to initdb

PGVERSION=9.5

LOCALEPARAMETER=$2
PGENGINE=/usr/ppas-$PGVERSION/bin
PGPORT=5432
PGDATA=/var/lib/ppas/$PGVERSION/data
PGLOG=/var/lib/ppas/$PGVERSION/pg_log/pgstartup.log
:<<0
/etc/sysconfig/ppas/ppas-9.5 文件内容如下
PGENGINE=/usr/ppas-9.5/bin
PGPORT=5432
PGDATA=/var/lib/ppas/9.5/data
PGLOG=/var/lib/ppas/9.5/pgstartup.log
0
[ -f /etc/sysconfig/ppas/ppas-9.5 ] && . /etc/sysconfig/ppas/ppas-9.5

export DATADIR="$PGDATA"


ExitScript()
{
    exit $1
}

checkdb()
{
    # Check for the PGDATA structure
    if [ ! -f "$PGDATA/PG_VERSION" ] && [ ! -d "$PGDATA/base" ]
    then
        echo "$PGDATA is missing."
        echo "$PGDATA is missing. Use \"$0 initdb\" to initialize the cluster first."

        ExitScript 1
    fi
}
initdb()
{
    # If the locale name is specified just after the initdb parameter, use it:
    if [ -z $LOCALEPARAMETER ]
    then
        LOCALE=`echo $LANG`
    else
        LOCALE=`echo $LOCALEPARAMETER`
    fi

    LOCALESTRING="--locale=$LOCALE"

    if [ -f "$PGDATA/PG_VERSION" ]
    then
        echo "Data directory is not empty!"
        ExitScript 2
    else
        echo -n $"Initializing database: "

        if [ ! -e "$PGDATA" -a ! -h "$PGDATA" ]
        then
            mkdir -p "$PGDATA" || exit 1
            chown enterprisedb:enterprisedb "$PGDATA"
            chmod go-rwx "$PGDATA"
        fi

        # Clean up SELinux tagging for PGDATA
        [ -x /sbin/restorecon ] && /sbin/restorecon "$PGDATA"

        # Make sure the startup-time log file is OK, too
        if [ ! -e "$PGLOG" -a ! -h "$PGLOG" ]
        then
            touch "$PGLOG" || exit 1
            chown enterprisedb:enterprisedb "$PGLOG"
            chmod go-rwx "$PGLOG"

            [ -x /sbin/restorecon ] && /sbin/restorecon "$PGLOG"
        fi

        # Initialize the database
        su -l enterprisedb -c "$PGENGINE/initdb --pgdata='$PGDATA' --auth='ident' $LOCALESTRING $INITDBOPTS" >> "$PGLOG" 2>&1 < /dev/null

        # Create directory for postmaster log
        mkdir "$PGDATA/pg_log"
        chown enterprisedb:enterprisedb "$PGDATA/pg_log"
        chmod go-rwx "$PGDATA/pg_log"

        [ ! -f "$PGDATA/PG_VERSION" ] && ExitScript 3
    fi
}

post_initdb()
{
    sed -i"" "s:\(^port.*\)5444:\1$PGPORT:g" $PGDATA/postgresql.conf
}

# See how we were called.
# -w : wait until operation completes
case "$1" in
  start)
        checkdb
        $PGENGINE/pg_ctl -w start -D "$PGDATA" -o "-p $PGPORT" -l "$PGLOG"

        ExitScript $?
        ;;
  stop)
        checkdb
        $PGENGINE/pg_ctl stop -m fast -w -D "$PGDATA"

        ExitScript $?
        ;;
  initdb)
        initdb
        post_initdb
        ;;
  "")
        echo "Usage: $0 {start|stop|initdb}"
        ;;

  *)
        echo "Usage: $0 {start|stop|initdb}"
esac

# Exit with the return code
ExitScript 0
