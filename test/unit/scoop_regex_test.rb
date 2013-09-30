require 'test_helper'

class ScoopRegexTest < ActiveSupport::TestCase

  setup do
    dump_database
    dump_jobs
    Delayed::Worker.delay_jobs=false
    load_scoop_database
  end

  test "regex codes work properly" do
    Delayed::Worker.delay_jobs=true
    mf = File.read('test/fixtures/scoop/codes_with_regex_map.js')
    rf = File.read('test/fixtures/scoop/scoop_general_reduce.js')
    query = Query.create(map: mf, reduce: rf)
    job = query.job
    job.invoke_job
    query.reload
    results = query.result
    assert_equal 10, results['>19_pop'].to_i
    assert_equal 2, results['>19_pop_bmi>30'].to_i
    assert_equal 1, results['>19_pop_overweight_wc'].to_i
    assert_equal 2, results['hasHeight'].to_i
    assert_equal 10, results['total_pop'].to_i
  end

end
