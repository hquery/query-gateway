require 'test_helper'

class RecordsControllerTest < ActionController::TestCase
  
  setup do
    dump_database
  end
  
  test "should POST a C32 to create" do
    c32 = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'fixtures', 'TobaccoUser0028.xml'), 'application/xml')
    post :create, {:content => c32}
    assert_response 201
    db = Mongoid.default_session
    #r = Mongoid.master['records'].find_one({:first => 'Unit', :last => 'Test'})
    r = db['records'].where({:first => 'Unit', :last => 'Test'}).first
    assert r
    assert_equal -773020800, r['birthdate']
  end

  test "should POST a E2E to create" do
    e2e = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'fixtures', 'JOHN_CLEESE_1_25091940.xml'), 'application/xml')
    post :create, {:content => e2e}
    assert_response 201
    db = Mongoid.default_session
    assert_equal 501, db[:records].find.count
    #r = db['records'].where({:first => 'JOHN', :last => 'CLEESE'}).first
    r = db[:records].where({ _id: 'oqG3YBB7rJvxeUAmPu2Mv2Q/cUji905I9IoJ4w==' }).first
    assert r
    assert_equal "", r['medical_record_number']
    assert_equal "", r['first']
    assert_equal "", r['last']
    assert_equal -923616000, r['birthdate']
    assert_equal "M", r['gender']
    performer = r['encounters'][0]['performer']
    assert_equal "doctor", performer['given_name']
    assert_equal "oscardoc", performer['family_name']
    assert_equal "999998", performer['npi']
  end

end
