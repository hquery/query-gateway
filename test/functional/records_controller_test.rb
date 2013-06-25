require 'test_helper'

class RecordsControllerTest < ActionController::TestCase
  
  setup do
    dump_database
  end
  
  test "should POST a C32 to create" do
    c32 = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'fixtures', 'TobaccoUser0028.xml'), 'application/xml')
    post :create, {:content => c32, :content_type => 'c32'}
    assert_response 201
    r = Mongoid.master['records'].find_one({:first => 'Unit', :last => 'Test'})
    assert r
    assert_equal -773020800, r['birthdate']
  end

  test "should POST a Scoop Basic XML to create" do
    c32 = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'fixtures', 'Sample-SCOOP-IT0-Document.xml'), 'application/xml')
    post :create, {:content => c32, :content_type => 'scoop_basic'}
    assert_response 201
    r = Mongoid.master['records'].find_one({:first => 'Henry', :last => 'Levin'})
    assert r
    assert_equal -1176163200, r['birthdate']
  end

end
