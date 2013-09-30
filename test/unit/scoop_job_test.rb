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
    assert_equal 4, results["male_>65"].to_i
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
    assert_equal 4, rvalues["filtered_pop_sum"].to_i
    assert_equal 6, rvalues["unfound_pop_sum"].to_i
    assert_equal 10, rvalues["total_pop_sum"].to_i
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
    assert_equal 7, results["senior_pop"].to_i
    assert_equal 2, results["senior_pop_digoxin_creatinine_abnormal"].to_i
    assert_equal 10, results["total_pop"].to_i
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
    assert_equal 10, results['>19_pop'].to_i
    assert_equal 2, results['>19_pop_bmi>30'].to_i
    assert_equal 1, results['>19_pop_overweight_wc'].to_i
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
    assert_equal 10, results['>19_pop'].to_i
    assert_equal 3, results['>19_pop_bp_diastolic'].to_i
    assert_equal 3, results['>19_pop_bp_systolic'].to_i
    assert_equal 1, results['>19_pop_heartrate'].to_i
    assert_equal 2, results['>19_pop_height'].to_i
    assert_equal 1, results['>19_pop_temperature'].to_i
    assert_equal 1, results['>19_pop_wc'].to_i
    assert_equal 2, results['>19_pop_weight'].to_i
    assert_equal 10, results['total_pop'].to_i
  end

end
