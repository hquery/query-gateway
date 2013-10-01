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
    assert_equal 2, results['numerator_has_recorded_values'].to_i
    assert_equal 10, results['denominator_patients_>19'].to_i
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
    assert_equal 2, results["numerator_has_hemoccult_result"].to_i
    assert_equal 5, results["denominator_patients_50-74"].to_i
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
    assert_equal 1, results["A10"].to_i
    assert_equal 4, results["B01"].to_i
    assert_equal 6, results["C03"].to_i
    assert_equal 3, results["C07"].to_i
    assert_equal 3, results["C09"].to_i
    assert_equal 4, results["C10"].to_i
    assert_equal 2, results["H03"].to_i
    assert_equal 2, results["M01"].to_i
    assert_equal 1, results["N02"].to_i
    assert_equal 1, results["N05"].to_i
    assert_equal 1, results["N06"].to_i
    assert_equal 8, results["R03"].to_i
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
    assert_equal 10, results['total_pop'].to_i
    assert_equal 4, results['denominator_diabetics'].to_i
    assert_equal 0, results['numerator_diabetics_bp'].to_i
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
    assert_equal 2, results["numerator_has_hgba1c_result"].to_i
    assert_equal 4, results["denominator_diabetics"].to_i
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
    assert_equal 2, results["has_hgba1c_result"].to_i
    assert_equal 2, results["numerator_has_matching_hgba1c_value"].to_i
    assert_equal 4, results["denominator_diabetics"].to_i
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
    assert_equal 2, results["has_ldl_result"].to_i
    assert_equal 1, results["numerator_has_matching_ldl_value"].to_i
    assert_equal 4, results["denominator_diabetics"].to_i
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
    assert_equal 2, results["numerator_has_blood_sugar_result"].to_i
    assert_equal 9, results["denominator_patients_>45"].to_i
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
    assert_equal 3, results["total_pneumovax"].to_i
    assert_equal 7, results["denominator_patients_>64"].to_i
    assert_equal 1, results["numerator_senior_pop_pneumovax"].to_i
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
    assert_equal 10, results["total_population"].to_i
    assert_equal 7, results["denominator_sampled_number"].to_i
    assert_equal 3, results["numerator_polypharmacy_number"].to_i
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
    assert_equal 1, results["female_40-49"].to_i
    assert_equal 1, results["female_50-59"].to_i
    assert_equal 1, results["female_60-69"].to_i
    assert_equal 1, results["female_70-79"].to_i
    assert_equal 2, results["female_80-89"].to_i
    assert_equal 1, results["male_60-69"].to_i
    assert_equal 2, results["male_70-79"].to_i
    assert_equal 1, results["male_90+"].to_i
    assert_equal 1, results["total_40-49"].to_i
    assert_equal 1, results["total_50-59"].to_i
    assert_equal 2, results["total_60-69"].to_i
    assert_equal 3, results["total_70-79"].to_i
    assert_equal 2, results["total_80-89"].to_i
    assert_equal 1, results["total_90+"].to_i
    assert_equal 6, results["total_female"].to_i
    assert_equal 4, results["total_male"].to_i
    assert_equal 10, results["total_population"].to_i
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
    assert_equal 4, results["had_statins"].to_i, 4
    assert_equal 4, results["denominator_has_current_statin"].to_i, 4
    assert_equal 2, results["numerator_no_mi_or_stroke"].to_i, 2
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
    assert_equal 7, results["senior_pop"].to_i
    assert_equal 3, results["denominator_senior_pop_impaired_renal"].to_i
    assert_equal 2, results["numerator_senior_pop_renal_digoxin"].to_i
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
    assert_equal 4, results["had_statins"].to_i
    assert_equal 4, results["denominator_has_current_statin"].to_i
    assert_equal 2, results["numerator_mi_or_stroke"].to_i
  end

end
