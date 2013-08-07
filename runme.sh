##!/bin/bash

bundle exec script/delayed_job start
bundle exec rails server -p 3001
bundle exec script/delayed_job stop
