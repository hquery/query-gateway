require 'factory_girl'

# ==========
# = jobs =
# ==========

Factory.define :queued_job, :class => Query do |q|
  q.map 'foo'
  q.reduce 'foo'
  q.job_logs [JobLog.new(:created_at => 60.seconds.ago.time, :message => 'Job queued')]
  q.status :queued
end

Factory.define :running_job, :class => Query do |q|
  q.map 'foo'
  q.reduce 'foo'
  q.job_logs [JobLog.new(:created_at => 60.seconds.ago.time, :message => 'Job queued'),
              JobLog.new(:created_at => 45.seconds.ago.time, :message => 'Job running')]
  q.status :running
end

Factory.define :successful_job, :class => Query do |q|
  q.map 'foo'
  q.reduce 'foo'
  q.job_logs [JobLog.new(:created_at => 60.seconds.ago.time, :message => 'Job queued'),
              JobLog.new(:created_at => 45.seconds.ago.time, :message => 'Job running'),
              JobLog.new(:created_at => 30.seconds.ago.time, :message => 'Job successful')]
  q.status :success
end

Factory.define :rescheduled_job,:class => Query do |q|
  q.map 'foo'
  q.reduce 'foo'
  q.job_logs [JobLog.new(:created_at => 60.seconds.ago.time, :message => 'Job queued'),
              JobLog.new(:created_at => 45.seconds.ago.time, :message => 'Job running'),
              JobLog.new(:created_at => 15.seconds.ago.time, :message => 'Job rescheduled')]
  q.status :rescheduled
end

Factory.define :failed_job, :class => Query do |q|
  q.map 'foo'
  q.reduce 'foo'
  q.job_logs [JobLog.new(:created_at => 60.seconds.ago.time, :message => 'Job queued'),
              JobLog.new(:created_at => 45.seconds.ago.time, :message => 'Job running'),
              JobLog.new(:created_at => 10.seconds.ago.time, :message => 'Job failed')]
  q.status :failed
end

