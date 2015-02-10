#!/bin/bash
source $HOME/.bash_profile
source $HOME/.bashrc
export ENDPOINT=$HOME/git/scoophealth/hquery/query-gateway
export GW_PIDFILE=$ENDPOINT/tmp/pids/server.pid
export DL_PIDFILE=$ENDPOINT/tmp/pids/delayed_job.pid
cd $ENDPOINT
if [ -f $DL_PIDFILE ];
then
  bundle exec $ENDPOINT/script/delayed_job stop
  # pid file should be gone but recheck
  if [ -f $DL_PIDFILE ];
  then
    rm $DL_PIDFILE
  fi
fi
#
# If gateway is running, stop it.
if [ -f $GW_PIDFILE ];
then
  kill `cat $GW_PIDFILE`
  if [ -f $GW_PIDFILE ];
  then
    kill -9 `cat $GW_PIDFILE`
  fi
  rm $GW_PIDFILE
fi
