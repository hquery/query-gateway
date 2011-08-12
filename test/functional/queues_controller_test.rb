require 'test_helper'
require 'net/http'

class QueuesControllerTest < ActionController::TestCase

  setup do
    dump_jobs
    dump_database
    Delayed::Worker.delay_jobs=true
  end
  
  def create_job_params_with_filter
    params = create_job_params
    params[:filter] = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/map_reduce/filter.json'), 'application/json')
    params
  end
  
  def create_job_params_with_bad_filter
    params = create_job_params
    params[:filter] = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/map_reduce/bad_filter.json'), 'application/json')
    params
  end
    
  test "POST should add a new job without filter" do
    assert Delayed::Job.all.count == 0 
    post :create, create_job_params
    assert_response 303
    assert Delayed::Job.all.count == 1
  end
  
  test "POST should add a new job with filter" do
    assert Delayed::Job.all.count == 0 
    post :create, create_job_params_with_filter
    assert_response 303
    assert Delayed::Job.all.count == 1
  end

  test "POST should fail with bad filter" do
    assert Delayed::Job.all.count == 0 
    begin
      post :create, create_job_params_with_bad_filter
      assert false
    rescue
      assert true
    end
  end

  test "GET /show show return a 404 when the job does not exist" do
    assert Delayed::Job.all.count == 0 
    get :show, {id: "4de8efb1b59a904045000008"}
    assert_response 404

  end
  
  test "GET /show show return a 500 error if the job failed" do
    job = QueryJob.submit("function(){}","function(){}") 
    job.failed_at = Time.now
    job.save
    job.payload_object.failure(job)
    get :show, {id: job.id.to_s}
    assert_response 500

  end
  
  test "GET /show show return a 303 response if the job is running or queued" do
    job = QueryJob.submit("function(){}","function(){}") 
    get :show, {id: job.id.to_s}
    assert_response 303

  end
  
  
  test "GET /show show return a 200 if the job is completed" do
    job = QueryJob.submit("function(){}","function(){}") 
    job.payload_object.success(job)
    Mongoid.master[QueryExecutor::RESULTS_COLLECTION].save({_id: job.id, value: {}})
    job_id = job.id.to_s
    job.destroy
    get :show, {id: job.id.to_s}
    assert_response :success

  end
  
  
  test "GET /show should return a 404 if the job is canceled" do

    assert Delayed::Job.all.count == 0 
    job = QueryJob.submit("function(){}","function(){}")
    assert Delayed::Job.all.count == 1
    job_id = job.id.to_s
    QueryJob.cancel_job(job_id)
    get :show, {id: job_id}
    assert_response 404
    assert Delayed::Job.all.count == 0

  end
  
  test "GET /job_status should retrieve a running jobs status if the job existed" do
    job = QueryJob.submit("function(){}","function(){}")
    get :job_status, {id: job.id.to_s}
    assert_response :success
  end
  
  test "GET /job_status should respond with a 404 if the job has not existed" do
    get :job_status, {id: "4de8efb1b59a904045000008"}
    assert_response 404
  end
  
  
  test "DELETE should delete a job" do
    assert Delayed::Job.all.count == 0 
    job = QueryJob.submit("function(){}","function(){}")
    assert Delayed::Job.all.count == 1 
    delete :destroy, {id: job.id.to_s}
    assert_response 200
    assert Delayed::Job.all.count == 0 
  end
  

  test "GET /server_status should render json for job status" do
    
    # add one of each job type (successful and failed jobs should be destroyed, events remain)
      Factory(:successful_job)
      Factory(:failed_job)
      Factory(:running_job)
      Factory(:running_job)
      Factory(:rescheduled_job)
      Factory(:queued_job)
      
      get :server_status
    
      assert_equal "application/json; charset=utf-8", @response.header['Content-Type']
      puts @response.body
      stats = JSON.parse(@response.body)
      
      assert_equal 1, stats['failed']
      assert_equal 2, stats['running']
      assert_equal 1, stats['rescheduled']
      assert_equal 1, stats['queued']
      assert_equal 1, stats['success']
      assert_equal 30, (stats['avg_runtime'] / 1000).to_i
    
      assert_response :success

  end
  
  # test "GET / should return all jobs" do
  #    get :index
  #    jobs = assigns[:jobs]
  #    assert_not_nil jobs
  #    assert_equal Delayed::Job.all.count, jobs.count
  #    assert_response :success
  #  end
  
end
