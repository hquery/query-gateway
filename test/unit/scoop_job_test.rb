require 'test_helper'

class ScoopJobTest < ActiveSupport::TestCase

  setup do
    dump_database
    dump_jobs
    Delayed::Worker.delay_jobs=false
    load_scoop_database
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

  test "iteration 0 query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/scoop_it0_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["male_>65"].to_i, 4
  end

  test "iteration 1 query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/scoop_it1_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["total_population"].to_i, 9
    assert_equal results["sampled_number"].to_i, 7
    assert_equal results["polypharmacy_number"].to_i, 3
  end

  test "iteration 2 query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/scoop_it2_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["B01AC"].to_i, 4
    assert_equal results["C01AA"].to_i, 2
    assert_equal results["C01CA"].to_i, 1
    assert_equal results["C03CA"].to_i, 3
    assert_equal results["C03DA"].to_i, 3
    assert_equal results["C07AG"].to_i, 3
    assert_equal results["C09AA"].to_i, 3
    assert_equal results["C10AA"].to_i, 4
    assert_equal results["H03AA"].to_i, 2
    assert_equal results["M01AE"].to_i, 2
    assert_equal results["N02AA"].to_i, 2
    assert_equal results["N02BE"].to_i, 4
    assert_equal results["N05BA"].to_i, 3
    assert_equal results["N06AB"].to_i, 1
    assert_equal results["R03AC"].to_i, 3
    assert_equal results["R03BA"].to_i, 2
    assert_equal results["R03BB"].to_i, 3
  end

  test "iteration 4 query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/scoop_it4_map.js')
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

  test "iteration 4b query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/scoop_it4b_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["senior_pop"].to_i, 7
    assert_equal results["senior_pop_digoxin_creatinine"].to_i, 2
    assert_equal results["total_pop"].to_i, 9
  end

  test "pneumococcal vaccine query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/pneumococcal_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["total_pneumovax"].to_i, 2
    assert_equal results["senior_pop_pneumovax"].to_i, 1
  end

  test "population profile query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/population_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["female_40-49"].to_i, 1
    assert_equal results["female_50-59"].to_i, 1
    assert_equal results["female_70-79"].to_i, 1
    assert_equal results["female_80-89"].to_i, 2
    assert_equal results["male_60-69"].to_i, 1
    assert_equal results["male_70-79"].to_i, 2
    assert_equal results["male_90+"].to_i, 1
    assert_equal results["total_40-49"].to_i, 1
    assert_equal results["total_50-59"].to_i, 1
    assert_equal results["total_60-69"].to_i, 1
    assert_equal results["total_70-79"].to_i, 3
    assert_equal results["total_80-89"].to_i, 2
    assert_equal results["total_90+"].to_i, 1
    assert_equal results["total_female"].to_i, 5
    assert_equal results["total_male"].to_i, 4
    assert_equal results["total_population"].to_i, 9
  end

  test "fasting blood sugar query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/fasting_blood_sugar_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["has_blood_sugar_result"].to_i, 1
    assert_equal results["patients_>45"].to_i, 8
  end

  test "colon screening query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/colon_screening_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["has_hemoccult_result"].to_i, 1
    assert_equal results["patients_50-74"].to_i, 4
  end

  test "diabetes hgba1c query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/diabetes_hgba1c_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["has_hgba1c_result"].to_i, 1
    assert_equal results["diabetics"].to_i, 3
  end

  test "diabetes hgba1c value query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/diabetes_hgba1c_value_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["has_hgba1c_result"].to_i, 1
    assert_equal results["has_matching_hgba1c_value"].to_i, 1
    assert_equal results["diabetics"].to_i, 3
  end

  test "diabetes ldl value query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/diabetes_ldl_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["has_ldl_result"].to_i, 1
    assert_equal results["has_matching_ldl_value"].to_i, 1
    assert_equal results["diabetics"].to_i, 3
  end

end
