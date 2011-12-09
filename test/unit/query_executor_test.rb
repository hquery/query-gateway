require 'test_helper'

class QueryExecutorTest < ActiveSupport::TestCase
  
  def setup   
    Mongoid.master.drop_collection('query_results')
    if defined?(QueryExecutor.test_setup)
      QueryExecutor.test_setup
    end

  end

  def test_execute
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    q = Query.create(map: mf, reduce: rf)
    qe = QueryJob::QueryExecutor.new(mf, rf, nil,q.id.to_s)

    results =  qe.execute
    assert_equal 213, results['M'].to_i
  end


end
