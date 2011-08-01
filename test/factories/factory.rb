require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '/factory_hash')

# ==========
# = Events =
# ==========
Factory.define :job_log_events, :class => FactoryHash do |u| 
  u.message 'job running'
  u.status ''
  u.time Time.now.to_s
  u.after_build {|event| event.collection(u.factory_name.to_s)}
end

Factory.define :successful_event, :parent => :job_log_events do |u| 
  u.status 'successful'
  u.time 30.seconds.ago.time
end
Factory.define :failed_event, :parent => :job_log_events do |u| 
  u.status 'failed'
  u.time 10.seconds.ago.time
end
Factory.define :queued_event, :parent => :job_log_events do |u| 
  u.status 'queued'
  u.time 60.seconds.ago.time
end
Factory.define :rescheduled_event, :parent => :job_log_events do |u| 
  u.status 'rescheduled'
  u.time 15.seconds.ago.time
end
Factory.define :running_event, :parent => :job_log_events do |u| 
  u.status 'running'
  u.time 45.seconds.ago.time
end


# ==========
# = jobs =
# ==========

Factory.define :delayed_backend_mongoid_jobs, :class => FactoryHash do |j|
  j.attempts 0
  j.priority 0
  j.created_at 60.seconds.ago.time
  j.after_build {|event| event.collection(j.factory_name.to_s)}
end

Factory.define :queued_job, :parent => :delayed_backend_mongoid_jobs do |j|
  j.after_create do |job|
    Factory(:queued_event, :job_id => job.id)
  end
end

Factory.define :running_job, :parent => :queued_job do |j|
  j.locked_by 'lock'
  j.locked_at 45.seconds.ago.time
  j.run_at 45.seconds.ago.time
  j.updated_at 45.seconds.ago.time
  j.after_create do |job|
    Factory(:running_event, :job_id => job.id)
  end
end

Factory.define :successful_job, :parent => :running_job do |j|
  j.after_create do |job|
    Factory(:successful_event, :job_id => job.id)
  end
end

Factory.define :rescheduled_job, :parent => :running_job do |j|
  j.attempts 2
  j.last_error 'failure'
  j.after_create do |job|
    Factory(:rescheduled_event, :job_id => job.id)
    Factory(:rescheduled_event, :job_id => job.id)
  end
end

Factory.define :failed_job, :parent => :rescheduled_job do |j|
  j.attempts 3
  j.last_error 'failure'
  j.after_create do |job|
    Factory(:failed_event, :job_id => job.id)
  end
end

