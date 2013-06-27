require 'factory_girl'

# ==========
# = jobs =
# ==========

FactoryGirl.define do
  factory :queued_job, :class => Query do |q|
    q.format 'js'
    q.map 'foo'
    q.reduce 'foo'
    q.job_logs [JobLog.new(:created_at => 60.seconds.ago.time, :message => 'Job queued')]
    q.status :queued
  end
end

FactoryGirl.define do
  factory :running_job, :class => Query do |q|
    q.format 'js'
    q.map 'foo'
    q.reduce 'foo'
    q.job_logs [JobLog.new(:created_at => 60.seconds.ago.time, :message => 'Job queued'),
                JobLog.new(:created_at => 45.seconds.ago.time, :message => 'Job running')]
    q.status :running
  end
end

FactoryGirl.define do
  factory :successful_job, :class => Query do |q|
    q.format 'js'
    q.map 'foo'
    q.reduce 'foo'
    q.job_logs [JobLog.new(:created_at => 60.seconds.ago.time, :message => 'Job queued'),
                JobLog.new(:created_at => 45.seconds.ago.time, :message => 'Job running'),
                JobLog.new(:created_at => 30.seconds.ago.time, :message => 'Job successful')]
    q.status :complete
  end
end

FactoryGirl.define do
  factory :rescheduled_job,:class => Query do |q|
    q.format 'js'
    q.map 'foo'
    q.reduce 'foo'
    q.job_logs [JobLog.new(:created_at => 60.seconds.ago.time, :message => 'Job queued'),
                JobLog.new(:created_at => 45.seconds.ago.time, :message => 'Job running'),
                JobLog.new(:created_at => 15.seconds.ago.time, :message => 'Job rescheduled')]
    q.status :rescheduled
  end
end

FactoryGirl.define do
  factory :failed_job, :class => Query do |q|
    q.format 'js'
    q.map 'foo'
    q.reduce 'foo'
    q.job_logs [JobLog.new(:created_at => 60.seconds.ago.time, :message => 'Job queued'),
                JobLog.new(:created_at => 45.seconds.ago.time, :message => 'Job running'),
                JobLog.new(:created_at => 10.seconds.ago.time, :message => 'Job failed')]
    q.status :failed
  end
end

# ===========
# = Results =
# ===========

FactoryGirl.define do
  factory :gender_result, :class => Result do |r|
    r.created_at Time.now
  end
end
