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
    r = db[:records].where({ hash_id: 'oqG3YBB7rJvxeUAmPu2Mv2Q/cUji905I9IoJ4w==' }).first
    refute_nil r
    assert_equal '1', r['_id']
    assert_equal '1', r['emr_demographics_primary_key']
    assert_equal 'cpsid', r['primary_care_provider_id']
    assert_equal "m59ceyj+C/6mnU2V32L/0G5XHZ3folWFlz8NTg==", r['medical_record_number']
    assert_equal "s/Q1SdAMY/S6mlao6erGW8sO1N0Z5XYXsSd2Ug==", r['first']
    assert_equal "7ETUHfZcSQduD+JS3qauh9vPmWUp1xbe56I3Bw==", r['last']
    assert_equal -923616000, r['birthdate']
    assert_equal "M", r['gender']
    performer = r['encounters'][0]['performer']
    assert_equal "", performer['given_name']
    assert_equal "qbGJGxVjhsCx/JR42Bd7tX4nbBYNgR/TehN7gQ==", performer['family_name']
    assert_equal performer['family_name'], performer['npi']
    #assert_equal "doctor", performer['given_name']
    #assert_equal "oscardoc", performer['family_name']
    #assert_equal "cpsid", performer['npi']
  end

  test "should POST another E2E to create" do
    e2e = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'fixtures', 'MZarilla.xml'), 'application/xml')
    post :create, {:content => e2e}
    assert_response 201
    db = Mongoid.default_session
    assert_equal 501, db[:records].find.count
    #r = db['records'].where({:first => 'Melvin', :last => 'Zarilla'}).first
    r = db[:records].where({ hash_id: '1vw2LeZgjRXW1Z00Xi97WII5Tbh0ln3ZN5xvbA==' }).first
    refute_nil r
    assert_equal '1vw2LeZgjRXW1Z00Xi97WII5Tbh0ln3ZN5xvbA==', r['_id']
    assert_equal nil, r['emr_demographics_primary_key']
    assert_equal '91604', r['primary_care_provider_id']
    assert_equal "xwoDLIzZNOJEqsIyDZsEBKghaFCEBNJp8cHPBA==", r['medical_record_number']
    assert_equal "1Z7vtn07FWZ4ZF60j5gbmUm37T7YA1skM6ABwg==", r['first']
    assert_equal "55uSmm6sHs6+WtpNh8HLeESBMgT/e79yROoGyA==", r['last']
    assert_equal Time.gm(2011,4,9).to_i, r['birthdate']
    assert_equal "F", r['gender']
    performer = r['encounters'][0]['performer']
    assert_equal "", performer['given_name']
    # performer is anonymized
    assert_equal "723CDj1qKtsyu1RWPnBZZ4xV+24qZMoEYh/BuQ==", performer['family_name']
    assert_equal performer['family_name'], performer['npi']
  end

end
