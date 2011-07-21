require 'test_helper'

class QueryJobTest < ActiveSupport::TestCase
  
  setup do
    dump_database
    dump_jobs
    Delayed::Worker.delay_jobs=false
  end
  
  test "job submission should execute properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    job = QueryJob.submit(mf,rf)
    assert_equal 1, Mongoid.master['job_log_events'].find({}).count
    assert_equal :queued, Mongoid.master['job_log_events'].find({}).first['status']
  end
  
  
  test "job status should report property" do
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
  
  test "success logs event properly" do
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    job = QueryJob.new(mf,rf,nil)

    running_job = Factory(:running_job)

    logger = MongoLogger.new
    count = logger.job_log(running_job.id).count

    job.success(running_job)
    
    logger = MongoLogger.new
    job_log = logger.job_log running_job.id

    assert_equal :successful, job_log.last['status']
    assert_equal count+1, job_log.count
    
  end

  test "error logs event properly" do
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    job = QueryJob.new(mf,rf,nil)

    running_job = Factory(:running_job)

    logger = MongoLogger.new
    count = logger.job_log(running_job.id).count

    job.error(running_job)
    
    logger = MongoLogger.new
    job_log = logger.job_log running_job.id

    assert_equal :error, job_log.last['status']
    assert_equal count+1, job_log.count
    
  end

  test "failure logs event properly" do
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    job = QueryJob.new(mf,rf,nil)

    running_job = Factory(:running_job)

    logger = MongoLogger.new
    count = logger.job_log(running_job.id).count

    job.failure(running_job)
    
    logger = MongoLogger.new
    job_log = logger.job_log running_job.id

    assert_equal :failed, job_log.last['status']
    assert_equal count+1, job_log.count
    
  end
  
  
end