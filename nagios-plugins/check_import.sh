#!/bin/sh
# Check current and previous tomcat6 log for pattern 'records pending' and
# 'records processed'.  If we check logs for the previous day there should
# be at least 2 pattern matches
LOGFILE=/var/log/tomcat6/catalina.out
LOGFILE1=/var/log/tomcat6/catalina.out.1.gz
DATE=`/bin/date --date='yesterday' +"%Y-%m-%d"`
TMPFILE=`/bin/tempfile`
CMD=`grep "records p" $LOGFILE > $TMPFILE 2>&1`
STATUS=$?
if [ $STATUS -ge 2 ]; then
  /bin/echo "UNKNOWN - Got $(/bin/cat $TMPFILE)"
  /bin/rm $TMPFILE
  exit 3
fi
CMD1=`zcat $LOGFILE1 | grep "records p" - >> $TMPFILE 2>&1`
STATUS1=$?
if [ $STATUS1 -ge 2 ]; then
  /bin/echo "UNKNOWN - Got $(/bin/cat $TMPFILE)"
  /bin/rm $TMPFILE
  exit 3
fi
COUNT=`grep "$DATE" $TMPFILE | wc -l`
if [ $COUNT -ge 2 ]; then
  COUNTP=`grep "$DATE" $TMPFILE | grep "records processed" | wc -l`
  if [ $COUNTP -ge 1 ]; then
    echo "OK - 'records processed' has $COUNTP matches on $DATE"
    /bin/rm $TMPFILE
    exit 0
  else
    echo "WARNING - 'records processed' has 0 matches on $DATE"
    /bin/rm $TMPFILE
    exit 1
  fi
fi
if [ $COUNT -eq 1 ]; then
  echo "WARNING - 'records p' has only 1 match on $DATE"
  /bin/rm $TMPFILE
  exit 1
else
  echo "CRITICAL - 'records p' has 0 matches on $DATE"
  /bin/rm $TMPFILE
  exit 2
fi
