require 'test_helper'

class LibraryFunctionsControllerTest < ActionController::TestCase

  setup do
    dump_database
  end

  test "should create library function" do
    function = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/library_function/simple_function.js'), 'application/javascript')
    post :create, functions: function, username: 'username1'
    
    assert_response :success
    
    db = Mongoid::Config.master
    assert_equal 'username1', db['system.js'].find({}).first['_id']
    assert_not_nil db['system.js'].find({}).first['value']['sum']
    
  end

end
