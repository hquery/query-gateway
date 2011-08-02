require 'test_helper'

class QueryJobTest < ActiveSupport::TestCase
  
  setup do
    dump_database
    dump_jobs
    Delayed::Worker.delay_jobs=false
  end
  
  test "job submission should execute properly" do
    Delayed::Worker.delay_jobs=true
    job = create_job
    assert_equal 1, Mongoid.master['job_logs'].find({}).count
    assert_equal :queued, Mongoid.master['job_logs'].find({}).first['status']
  end
  
  
  test "job status should report property" do
     Delayed::Worker.delay_jobs=true
     job = create_job
     payload = job.payload_object
     job_id = job.id
     assert_equal QueryJob.job_status(job_id.to_s), :queued
     
     payload.before(job)
     assert_equal QueryJob.job_status(job_id.to_s), :running
     
     payload.failure(job)
     assert_equal QueryJob.job_status(job_id.to_s), :failed
     
     Mongoid.master[QueryExecutor::RESULTS_COLLECTION].save({_id: job.id, value: {}})
     assert_equal QueryJob.job_status(job_id.to_s), :failed
     
     payload.success(job) 
     assert_equal QueryJob.job_status(job_id.to_s), :success
     
     job.destroy()
     JobLog.first({conditions: {job_id:job_id.to_s}}).destroy()
     Mongoid.master[QueryExecutor::RESULTS_COLLECTION].remove()
     assert_equal QueryJob.job_status(job_id.to_s), :not_found
  end
  
  test "success logs event properly" do
    Delayed::Worker.delay_jobs=true
    job = create_job
    job.payload_object.success(job)
    job_log = JobLog.first(:conditions => {job_id: job.id.to_s})
    assert_equal :success, job_log.status    
  end

  test "error logs event properly" do
    Delayed::Worker.delay_jobs=true
    job = create_job
    count = JobLog.first(:conditions => {job_id: job.id.to_s}).messages.count
    job.payload_object.error(job)
    job_log = JobLog.first(:conditions => {job_id: job.id.to_s})
    assert_equal :error, job_log.status
    
  end

  test "failure logs event properly" do
    Delayed::Worker.delay_jobs=true
    job = create_job
    count = JobLog.first(:conditions => {job_id: job.id.to_s}).messages.count
    job.payload_object.failure(job)
    job_log =JobLog.first(:conditions => {job_id: job.id.to_s})
    assert_equal :failed, job_log.status
    assert_equal count+1, job_log.messages.count
    
  end

  test "before logs running event properly" do
    Delayed::Worker.delay_jobs=true
    job = create_job
    job.payload_object.before(job)
    job_log = JobLog.first(:conditions => {job_id: job.id.to_s})
    assert_equal :running, job_log.status
    
  end


  
  test "Job executes correctly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    job = QueryJob.submit(mf,rf,nil)   
    job.invoke_job
    results = QueryJob.job_results(job.id.to_s)
    assert_equal results["M"], 231
    assert_equal results["F"], 275
  end

  
  test "test cancel job" do
    Delayed::Worker.delay_jobs=true
    job = create_job
    job_id = job.id
    assert_equal Delayed::Job.count() , 1
    QueryJob.cancel_job(job_id.to_s)
    assert_equal Delayed::Job.count() , 0 
    assert_equal :canceled,  QueryJob.job_status(job_id.to_s)
  end
  
  
end