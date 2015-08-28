require 'test_helper'

class SysinfoControllerTest < ActionController::TestCase
  test "should get currentload" do
    get :currentload
    assert_response :success
  end

  test "should get currentusers" do
    get :currentusers
    assert_response :success
  end

  test "should get diskspace" do
    get :diskspace
    assert_response :success
  end

  test "should get mongo" do
    get :mongo
    assert_response :success
  end

  test "should get totalprocesses" do
    get :totalprocesses
    assert_response :success
  end

  test "should get swap" do
    get :swap
    assert_response :success
  end

end
