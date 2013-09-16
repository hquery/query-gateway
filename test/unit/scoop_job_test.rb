require 'test_helper'

class ScoopJobTest < ActiveSupport::TestCase

  setup do
    dump_database
    dump_jobs
    Delayed::Worker.delay_jobs=false
    load_scoop_database
  end

  test "age gender query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/age_gender_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["male_>65"].to_i, 4
  end

  test "graphical query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/graphical_builder_demographics_map.js')
    rf = File.read('test/fixtures/scoop/graphical_builder_demographics_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_not_nil results
    rvalues = results["{\"type\"=>\"population\"}"]['values']
    assert_equal rvalues["filtered_pop_sum"].to_i, 4
    assert_equal rvalues["unfound_pop_sum"].to_i, 5
    assert_equal rvalues["total_pop_sum"].to_i, 9
  end

  test "renal digoxin query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/renal_digoxin_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["senior_pop"].to_i, 7
    assert_equal results["senior_pop_digoxin_creatinine_abnormal"].to_i, 2
    assert_equal results["total_pop"].to_i, 9
  end

  test "vital signs overweight query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/vital_sign_overweight_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal 9, results['>19_pop']
    assert_equal 0, results['>19_pop_overweight_wc']
    assert_equal 1, results['>19_pop_bmi>30']
  end

  test "vital signs query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/vital_signs_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal 9, results['total_pop']
    assert_equal 9, results['>19_pop']
    assert_equal 1, results['>19_pop_heartrate']
    assert_equal 2, results['>19_pop_bp_systolic']
    assert_equal 2, results['>19_pop_bp_diastolic']
    assert_equal 1, results['>19_pop_temperature']
    assert_equal 1, results['>19_pop_height']
    assert_equal 1, results['>19_pop_weight']
    assert_equal 1, results['>19_pop_wc']
  end

end
