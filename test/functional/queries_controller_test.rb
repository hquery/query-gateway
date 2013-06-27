require 'test_helper'

class QueriesControllerTest < ActionController::TestCase
  
  setup do
    dump_database
  end
  
  test "should get an atom feed at index" do
    FactoryGirl.create(:successful_job)
    FactoryGirl.create(:successful_job)
    get :index, :format => :atom
    assert_response :success
  end
  
  test "should get a form at new" do
    get :new, :format => :html
    assert_response :success
  end
  
  test "POST should add a new job without filter or functions" do
    job_params = create_job_params
    job_params.delete(:functions)
    job_params.delete(:filter)
    post :create, job_params
    assert_response 201
    assert assigns(:query).map.include? 'gender'
    puts assigns(:query).functions
    assert assigns(:query).functions.nil?  
  end
  
  test "POST should add a new job with filter and functions" do
    post :create, create_job_params
    assert_response 201
    assert assigns(:query).map.include? 'gender'
    assert assigns(:query).functions.include? 'sum'
  end
  
  test "POST should add a new job from HQMF" do
    post :create, create_hqmf_job_params
    assert_response 201
    assert assigns(:query).map.include? 'IPP'
    assert assigns(:query).functions.include? 'IPP'
  end
  
  test "HQMF form upload processing" do
    post :upload_hqmf, create_hqmf_upload
    assert_response :redirect
    assert assigns(:query).map.include? 'IPP'
    assert assigns(:query).functions.include? 'IPP'
  end
  
  test "should reject jobs without a reduce function" do
    job_params = create_job_params
    job_params.delete(:reduce)
    post :create, job_params
    assert_response 400
  end
  
  test 'should show JSON for a successful job' do
    query = FactoryGirl.create(:successful_job)
    get :show, :id => query.id.to_s
    assert_response :success
  end
end
