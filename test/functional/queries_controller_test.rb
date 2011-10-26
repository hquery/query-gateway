require 'test_helper'

class QueriesControllerTest < ActionController::TestCase
  
  test "should get an atom feed at index" do
    Factory(:successful_job)
    Factory(:successful_job)
    get :index, :format => :atom
    assert_response :success
  end
  
  test "POST should add a new job without filter or functions" do
    job_params = create_job_params
    job_params.delete(:functions)
    post :create, job_params
    assert_response 201
    assert assigns(:query).map.include? 'gender'
    puts assigns(:query).functions
    assert assigns(:query).functions.nil?
    
  end
  
  
  test "POST should add a new job with functions" do
    post :create, create_job_params
    assert_response 201
    assert assigns(:query).map.include? 'gender'
    assert assigns(:query).functions.include? 'sum'
  end
  
  test "should reject jobs without a reduce function" do
    job_params = create_job_params
    job_params.delete(:reduce)
    post :create, job_params
    assert_response 400
  end
  
  test 'should show JSON for a successful job' do
    query = Factory(:successful_job)
    get :show, :id => query.id.to_s
    assert_response :success
  end
end
