#!/bin/bash
set -e  # exit on errors
# Example usage from cron:
# 15 8 * * * /encrypted/root/mysql_reload.sh >> /encrypted/root/log/reload.log 2>&1
#
# Stop Tomcat. Nagios test of whether load succeeded
# checks whether this script restarted Tomcat.
# That will happen if script runs to completion.
# In any case, Oscar cannot run while the database
# is being restored from a dump.
echo "Stopping Tomcat at `date`"
/etc/init.d/tomcat6 stop
#
echo "Datebase dump inspection started at `date`"
DUMPFILE="/encrypted/somedir/somedump.sql"
CMD=`find $DUMPFILE -mtime 0 -print | wc -l`
if [ $CMD -eq 0 ]
then
  HOST=`/bin/hostname`
  echo "Check why the EMR SQL dump on $HOST failed to update for `date`."
  exit
fi
echo "Database dump appears current"
echo "Database reloading started at `date`"
DBNAME="oscar_12_1"
PASSWD="somepasswd"
#
mysql -uroot -p$PASSWD -e "drop database $DBNAME;"
mysql -uroot -p$PASSWD -e "create database $DBNAME;"
mysql -uroot -p$PASSWD $DBNAME < $DUMPFILE
#
echo "Completed database reload at `date`"
# restart Oscar
/etc/init.d/tomcat6 start
echo "Tomcat restart completed at `date`"
