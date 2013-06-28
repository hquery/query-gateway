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
end