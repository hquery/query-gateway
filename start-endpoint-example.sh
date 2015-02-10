#!/bin/bash
#export HOME=/home/scoopadmin
source $HOME/.bash_profile
source $HOME/.bashrc
export ENDPOINT=$HOME/git/scoophealth/hquery/query-gateway
export GW_PIDFILE=$ENDPOINT/tmp/pids/server.pid
export DL_PIDFILE=$ENDPOINT/tmp/pids/delayed_job.pid
#
# Make sure mongod is running
if ! pgrep mongod > /dev/null
then
  sudo service mongod start
fi
#
#echo "Starting relay service on port 3000"
#$ENDPOINT/util/relay-service.rb >> $HOME/logs/rs.log 2>&1 &
#
echo "Starting Query Gateway on port 3001"
cd $ENDPOINT
# Stop delayed_job if running, remove pidfile
if [ -f $DL_PIDFILE ];
then
  bundle exec $ENDPOINT/script/delayed_job stop
  if [ -f $DL_PIDFILE ];
  then
    rm $DL_PIDFILE
  fi
fi
#
bundle exec $ENDPOINT/script/delayed_job start
#
# Start gateway
# If gateway is already running (or has a stale server.pid), try to stop it.
if [ -f $GW_PIDFILE ];
then
  kill `cat $GW_PIDFILE`
  if [ -f $GW_PIDFILE ];
  then
    kill -9 `cat $GW_PIDFILE`
  fi
  rm $GW_PIDFILE
fi
bundle exec rails server -p 3001 >> $ENDPOINT/log/qgw.log 2>&1 &
#/bin/ps -ef | grep "rails server -p 3001" | grep -v grep | awk '{print $2}' > tmp/pids/server.pid
