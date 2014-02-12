::Windows Normal Gateway Startup Script

@echo off
echo "Installing Dependencies"
call bundle install
echo "Starting Delayed Job"
call "cmd /c start /min bundle exec ruby script/delayed_job run"
echo "Starting Normal Gateway"
bundle exec rails server -p 3001
