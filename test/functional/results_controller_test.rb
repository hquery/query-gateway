require 'test_helper'

class ResultsControllerTest < ActionController::TestCase
  setup do
    dump_database
  end
  
  test "should get an atom feed at index" do
    get :index, :format => :atom
    assert_response :success
  end

  test "should get an individual result" do
    Factory(:gender_result)
    r = Result.first
    get :show, :id => r.id
    assert_response :success
  end

end
