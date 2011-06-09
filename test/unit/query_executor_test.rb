require 'test_helper'

class QueryExecutorTest < ActiveSupport::TestCase
  def setup
    Mongoid.master.drop_collection('query_results')
  end
  
  def test_execute
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    qe = QueryExecutor.new(mf, rf, 24601)
    qe.execute
    
    results = Mongoid.master['query_results'].find_one('_id' => 24601)
    assert_equal 231, results['M']
  end
  
  def test_execute_with_all_male_query

    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    qe = QueryExecutor.new(mf, rf, 24601, {gender: "M"})
    qe.execute
    
    results = Mongoid.master['query_results'].find_one('_id' => 24601)
    
    assert_equal 231, results['M']
    assert_equal nil, results['F']
  end
  
  def test_execute_with_birthdate_query
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    
    # 739558907 = 18 years ago from June 8, 2011
    qe = QueryExecutor.new(mf, rf, 24601, {birthdate: {"$gt" => 739558907}})
    qe.execute
    
    results = Mongoid.master['query_results'].find_one('_id' => 24601)
    
    assert_equal 62, results['M']
    assert_equal 57, results['F']
  end
  
end