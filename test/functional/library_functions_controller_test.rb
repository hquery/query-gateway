require 'test_helper'

class LibraryFunctionsControllerTest < ActionController::TestCase

  setup do
    dump_database
  end

  test "should create library function" do
    user_id = '123ffa';
    composer_id = 'dummy_composer_id'
    function = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/library_function/simple_function.js'), 'application/javascript')
    post :create, functions: function, user_id: user_id, composer_id: composer_id
    
    assert_response :success
    
    db = Mongoid::Config.master
    assert_equal 'hquery_user_functions', db['system.js'].find({}).first['_id']
    assert_not_nil db['system.js'].find({}).first['value']['f'+composer_id]['f'+user_id]['sum']
    
  end

  test "should create library function with existing function" do
    
    # add some existing data at the composer level
    db = Mongoid::Config.master
    user_namespace = "hquery_user_functions = {}; hquery_user_functions['foobar'] = {};"
    db.eval(user_namespace)
    db.eval("db.system.js.save({_id:'hquery_user_functions', value : hquery_user_functions })")
    
    user_id = '123ffa';
    composer_id = 'dummy_composer_id'
    function = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/library_function/simple_function.js'), 'application/javascript')
    post :create, functions: function, user_id: user_id, composer_id: composer_id
    
    assert_response :success
    
    db = Mongoid::Config.master
    assert_equal 'hquery_user_functions', db['system.js'].find({}).first['_id']
    # make sure we have not blown away the existing data
    assert_not_nil db['system.js'].find({}).first['value']['foobar']
    # make sure the new stuff is there as well
    assert_not_nil db['system.js'].find({}).first['value']['f'+composer_id]['f'+user_id]['sum']
    
  end

end
