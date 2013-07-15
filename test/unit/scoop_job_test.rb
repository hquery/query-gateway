require 'test_helper'

class ScoopJobTest < ActiveSupport::TestCase
  
  setup do
    dump_database
    dump_jobs
    Delayed::Worker.delay_jobs=false
    load_scoop_database
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

  test "iteration graphical query works properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/graphical_builder_demographics_map.js')
    rf = File.read('test/fixtures/scoop/graphical_builder_demographics_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    #puts results.inspect
    assert_not_nil results
    #assert_equal results["filtered_pop_sum"].to_i, 4
    #assert_equal results["unfound_pop_sum"].to_i, 5
    #assert_equal results["total_pop_sum"].to_i, 9
  end
end
