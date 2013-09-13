#!/bin/sh
# Start Normal HTTP Gateway

echo "Installing Dependencies"
bundle install
echo "Starting Delayed Job"
bundle exec script/delayed_job start
echo "Starting Normal Gateway"
bundle exec rails server -p 3001
echo "Stopping Delayed Job"
bundle exec script/delayed_job stop
