require 'test_helper'

class QueryJobTest < ActiveSupport::TestCase
  
  setup do
    dump_database
    dump_jobs
    Delayed::Worker.delay_jobs=false
  end
  
  test "job submission should execute properly" do
    Delayed::Worker.delay_jobs=true
    query = create_query
    query.job
    #assert_equal 1, Mongoid.master['queries'].find({}).count
    #assert_equal :queued, Mongoid.master['queries'].find({}).first['status']
    db = Mongoid.default_session
    assert_equal 1, db['queries'].find({}).count
    assert_equal :queued, db['queries'].find({}).first['status']
  end
  
  
  test "job status should report property" do
    Delayed::Worker.delay_jobs=true
    query = create_query
    job = query.job
    payload = job.payload_object
    job_id = job.id
    assert_equal Query.find(query.id).status, :queued

    payload.before(job)
    assert_equal Query.find(query.id).status, :running

    payload.failure(job)
    assert_equal Query.find(query.id).status, :failed

    #Result.collection.save({_id: job.id, value: {}})
    Result.collection.insert({_id: job.id, value: {}})
    assert_equal Query.find(query.id).status, :failed

    payload.success(job) 
    assert_equal Query.find(query.id).status, :complete
  end
  
  test "success logs event properly" do
    Delayed::Worker.delay_jobs=true
    query = create_query
    job = query.job
    job.payload_object.success(job)
    query = Query.find(query.id)
    assert_equal :complete, query.status
    assert query.job_logs.where(message: 'Job successful')
  end

  test "error logs event properly" do
    Delayed::Worker.delay_jobs=true
    query = create_query
    job = query.job
    job.payload_object.error(job)
    query.reload
    assert_equal :error, query.status
  end

  test "failure logs event properly" do
    Delayed::Worker.delay_jobs=true
    query = create_query
    job = query.job
    query.reload
    count = query.job_logs.count
    job.payload_object.failure(job)
    query.reload
    assert_equal :failed, query.status
    assert_equal count + 1, query.job_logs.count
  end

  test "before logs running event properly" do
    Delayed::Worker.delay_jobs=true
    query = create_query
    job = query.job
    job.payload_object.before(job)
    query.reload
    assert_equal :running, query.status
  end

  test "Job executes correctly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["M"].to_i, 213
    assert_equal results["F"].to_i, 287
  end

  test "Job executes correctly with function" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/map_reduce/simple_map_with_function.js')
    functions = File.read('test/fixtures/library_function/simple_function.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    query = Query.create(map: mf, reduce: rf, functions: functions)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["M"].to_i, 213
    assert_equal results["F"].to_i, 287
  end
  
  test "test cancel job" do
    Delayed::Worker.delay_jobs=true
    query = create_query
    job = query.job
    job_id = job.id
    assert_equal Delayed::Job.count() , 1
    QueryJob.cancel_job(job_id.to_s)
    assert_equal Delayed::Job.count() , 0
    query.reload
    assert_equal :canceled, query.status
  end
end