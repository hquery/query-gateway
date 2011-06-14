require 'test_helper'

class QueryJobTest < ActiveSupport::TestCase
  def setup
   Delayed::Job.destroy_all
   Delayed::Worker.delay_jobs=false
  end
  
  def test_execute
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    job = QueryJob.submit(mf,rf)
    
  end
  
  
  def test_job_status
     Delayed::Worker.delay_jobs=true
     mf = File.read('test/fixtures/map_reduce/simple_map.js')
     rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
     job = QueryJob.submit(mf,rf)
     
     job_id = job.id
     assert_equal QueryJob.job_status(job_id.to_s), :queued
     
     job.locked_at = Time.now
     job.save
     assert_equal QueryJob.job_status(job_id.to_s), :running
     
     job.failed_at = Time.now
     job.save
     assert_equal QueryJob.job_status(job_id.to_s), :failed
     
     Mongoid.master[QueryExecutor::RESULTS_COLLECTION].save({_id: job.id, value: {}})
     assert_equal QueryJob.job_status(job_id.to_s), :failed
     
     job.destroy()
     assert_equal QueryJob.job_status(job_id.to_s), :completed
     
     Mongoid.master[QueryExecutor::RESULTS_COLLECTION].remove()
     assert_equal QueryJob.job_status(job_id.to_s), :not_found
     
     
  end
  
  
end