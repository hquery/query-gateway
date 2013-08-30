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
    #assert_equal 'xyz', results
    assert_equal 9, results['>19_pop']
    assert_equal 0, results['>19_pop_overweight_wc']
    assert_equal 1, results['>19_pop_bmi>30']
    assert_equal 1, results['hasHeight']
  end

end
