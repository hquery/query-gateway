#!/bin/sh
# Start Secure HTTPS Gateway

echo "Installing Dependencies"
bundle install
echo "Starting Delayed Job"
bundle exec script/delayed_job start
echo "Starting Secure Gateway"
bundle exec script/secure_rails server -p 3222
echo "Stopping Delayed Job"
bundle exec script/delayed_job stop
