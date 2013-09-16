require 'test_helper'

class PdcJobTest < ActiveSupport::TestCase

  setup do
    dump_database
    dump_jobs
    Delayed::Worker.delay_jobs=false
    load_scoop_database
  end

  test "bmi wc query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/bmi_wc_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal 9, results['>19_pop']
    assert_equal 0, results['>19_pop_overweight_wc']
    assert_equal 1, results['>19_pop_bmi>30']
  end

  test "colon screening query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/colon_screening_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["has_hemoccult_result"].to_i, 1
    assert_equal results["patients_50-74"].to_i, 4
  end

  test "commonly prescribed medications query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/common_medication_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
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

  test "diabetes and bp query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/diabetes_bp_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal 9, results['total_pop']
    assert_equal 9, results['pop']
    assert_equal 3, results['diabetics']
    assert_equal 0, results['diabetics_bp']
    #assert_equal 'xyz', results
  end

  test "diabetes hgba1c query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/diabetes_hgba1c_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
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
    mf = File.read('test/fixtures/pdc/diabetes_hgba1c_value_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
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
    mf = File.read('test/fixtures/pdc/diabetes_ldl_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["has_ldl_result"].to_i, 1
    assert_equal results["has_matching_ldl_value"].to_i, 1
    assert_equal results["diabetics"].to_i, 3
  end

  test "fasting blood sugar query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/fasting_blood_sugar_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["has_blood_sugar_result"].to_i, 1
    assert_equal results["patients_>45"].to_i, 8
  end

  test "pneumococcal vaccine query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/pneumococcal_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["total_pneumovax"].to_i, 2
    assert_equal results["senior_pop_pneumovax"].to_i, 1
  end

  test "polypharmacy query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/polypharmacy_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["total_population"].to_i, 9
    assert_equal results["sampled_number"].to_i, 7
    assert_equal results["polypharmacy_number"].to_i, 3
  end

  test "population profile query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/population_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
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

  test "primary statins query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/primary_statins_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["had_statins"].to_i, 4
    assert_equal results["has_current_statin"].to_i, 4
    assert_equal results["no_mi_or_stroke"].to_i, 2
  end

  test "renal digoxin value query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/renal_digoxin_value_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["senior_pop"].to_i, 7
    assert_equal results["senior_pop_digoxin_creatinine"].to_i, 2
    assert_equal results["total_pop"].to_i, 9
  end

  test "secondary statins query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/pdc/secondary_statins_map.js')
    rf = File.read('test/fixtures/pdc/pdc_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal results["had_statins"].to_i, 4
    assert_equal results["has_current_statin"].to_i, 4
    assert_equal results["mi_or_stroke"].to_i, 2
  end

end
