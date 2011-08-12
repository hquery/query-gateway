require 'test_helper'

class HdataControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get and atom feed at index, if desired" do
    get :index, :format => :atom
    assert_response :success
  end

  test "should get root" do
    get :root, :format => :xml
    assert_response :success
  end

end
