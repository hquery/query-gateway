require 'test_helper'

class ResultsControllerTest < ActionController::TestCase
  setup do
    dump_database
    FactoryGirl.create(:gender_result)
  end
  
  test "should get an atom feed at index" do
    get :index, :format => :atom
    assert_response :success
  end

  test "should get an individual result" do
    r = Result.first
    get :show, :id => r.id
    assert_response :success
  end

end
