require 'test_helper'

class RecordsControllerTest < ActionController::TestCase
  
  setup do
    dump_database
  end
  
  test "should POST a C32 to create" do
    c32 = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'fixtures', 'TobaccoUser0028.xml'), 'application/xml')
    post :create, {:content => c32}
    assert_response 201
    r = Mongoid.master['records'].find_one({:first => 'Unit', :last => 'Test'})
    assert r
    assert_equal -773020800, r['birthdate']
  end

  test "should POST a E2E to create" do
    e2e = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'fixtures', 'JOHN_CLEESE_1_25091940.xml'), 'application/xml')
    post :create, {:content => e2e}
    assert_response 201
    r = Mongoid.master['records'].find_one({:first => 'JOHN', :last => 'CLEESE'})
    assert r
    assert_equal -923616000, r['birthdate']
  end

end
