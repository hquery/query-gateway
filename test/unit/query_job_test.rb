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

  test "before logs running event properly" do
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    job = QueryJob.new(mf,rf,nil)

    running_job = Factory(:running_job)

    logger = MongoLogger.new
    count = logger.job_log(running_job.id).count

    job.before(running_job)
    
    logger = MongoLogger.new
    job_log = logger.job_log running_job.id

    assert_equal :running, job_log.last['status']
    assert_equal 'lock', job_log.last['worker']
    assert_equal 'Job running', job_log.last['message']
    assert_equal count+1, job_log.count
    
  end

  test "after logs rescheduled event properly" do
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    job = QueryJob.new(mf,rf,nil)

    running_job = Factory(:running_job)

    logger = MongoLogger.new
    count = logger.job_log(running_job.id).count

    job.after(running_job)
    
    logger = MongoLogger.new
    job_log = logger.job_log running_job.id

    assert_equal :queued, job_log.last['status']
    assert_equal "Job rescheduled", job_log.last['message']
    assert_equal count+1, job_log.count
    
  end
  
  test "perform calls query executor" do
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    job = QueryJob.new(mf,rf,nil)
    
    running_job = Factory(:running_job)
    job.before(running_job)
    
    # TODO: aq - expects is not working properly with mocha and rails 3.1.0.rc4... passes even though not called
    QueryExecutor.any_instance.expects(:execute).once.returns(false)
    
    job.perform
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