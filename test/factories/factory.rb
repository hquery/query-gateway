require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '/factory_hash')

# ==========
# = Events =
# ==========
Factory.define :job_logs, :class => JobLog do |u| 
  u.messages [] 
  u.status ''
  u.last_update Time.now.to_s
  
end


Factory.define :queued_event, :parent => :job_logs do |u| 
  u.status :queued
  u.last_update 60.seconds.ago.time
  u.after_create do |log|
      log.messages << {status:"queued", time:60.seconds.ago.time}
  end
end

Factory.define :running_event, :parent => :queued_event do |u| 
  u.status :running
  u.last_update 45.seconds.ago.time
  u.after_create do |log|
      log.messages << {status:"running", time:45.seconds.ago.time}
  end
end

Factory.define :successful_event, :parent => :running_event do |u| 
  u.status :success
  u.last_update 30.seconds.ago.time
  u.after_create do |log|
      log.messages << {status:"success", time:30.seconds.ago.time}
  end
end

Factory.define :error_event, :parent => :running_event do |u| 
  u.status :error
  u.last_update 60.seconds.ago.time
  u.after_create do |log|
      log.messages << {status:"error", time:60.seconds.ago.time}
  end
end

Factory.define :rescheduled_event, :parent => :error_event do |u| 
  u.status :rescheduled
  u.last_update 15.seconds.ago.time
  u.after_create do |log|
      log.messages << {status:"rescheduled", time:15.seconds.ago.time}
  end
end


Factory.define :failed_event, :parent => :running_event do |u| 
  u.status :failed
  u.last_update 10.seconds.ago.time
  u.after_create do |log|
      log.messages << {status:"failed", time:10.seconds.ago.time}
  end
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
    Factory(:queued_event, :job_id=>job.id.to_s, :job=>job)
  end
end

Factory.define :running_job, :parent => :delayed_backend_mongoid_jobs do |j|
  j.locked_by 'lock'
  j.locked_at 45.seconds.ago.time
  j.run_at 45.seconds.ago.time
  j.updated_at 45.seconds.ago.time
  j.after_create do |job|
      Factory(:running_event, :job_id=>job.id.to_s, :job=>job)
  end
end

Factory.define :successful_job, :parent => :delayed_backend_mongoid_jobs do |j|
  j.after_create do |job|
    Factory(:successful_event, :job_id=>job.id.to_s, :job=>job)
  end
end

Factory.define :rescheduled_job, :parent => :delayed_backend_mongoid_jobs do |j|
  j.attempts 2
  j.last_error 'failure'
  j.after_create do |job|
    Factory(:rescheduled_event, :job_id=>job.id.to_s, :job=>job)
  end
end

Factory.define :failed_job, :parent => :delayed_backend_mongoid_jobs do |j|
  j.attempts 3
  j.last_error 'failure'
  j.after_create do |job|
     Factory(:failed_event, :job_id=>job.id.to_s, :job=>job)
  end
end

