require 'test_helper'

class QueuesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    Delayed::Job.destroy_all
    Delayed::Worker.delay_jobs=true
  end
  
  
  def create_job_params
     map = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/map_reduce/simple_map.js'), 'application/javascript')
     reduce = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/map_reduce/simple_reduce.js'), 'application/javascript')
     {:map => map, :reduce => reduce}
  end
  
  def clear_jobs
     Delayed::Job.destroy_all
  end
  
  test "POST should add a new job" do
    assert Delayed::Job.all.count == 0 
    post :create, create_job_params
    assert_response 303
    assert Delayed::Job.all.count == 1
  end


  test "GET /show show return a 404 when the job does not exist" do
    clear_jobs
    assert Delayed::Job.all.count == 0 
    get :show, {id: "4de8efb1b59a904045000008"}
    assert_response 404

  end
  
  test "GET /show show return a 500 error if the job failed" do
    clear_jobs
    job = QueryJob.submit("function(){}","function(){}") 
    job.failed_at = Time.now
    job.save
    get :show, {id: job.id.to_s}
    assert_response 500

  end
  
  test "GET /show show return a 303 response if the job is running or queued" do
    clear_jobs
    job = QueryJob.submit("function(){}","function(){}") 
    get :show, {id: job.id.to_s}
    assert_response 303

  end
  
  
  test "GET /show show return a 200 if the job is completed" do
    clear_jobs
    job = QueryJob.submit("function(){}","function(){}") 
    Mongoid.master[QueryExecutor::RESULTS_COLLECTION].save({_id: job.id, value: {}})
    job_id = job.id.to_s
    job.destroy
    get :show, {id: job.id.to_s}
    assert_response 200

  end
  
  test "GET /job_status should retrieve a running jobs status if the job existed" do
    clear_jobs
    job = QueryJob.submit("function(){}","function(){}")
    get :job_status, {id: job.id.to_s}
    assert_response 200

  end
  
  test "GET /job_status should respond with a 404 if the job has not existed" do
    clear_jobs

    get :job_status, {id: "4de8efb1b59a904045000008"}
    assert_response 404

  end
  
end
