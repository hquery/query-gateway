require 'test_helper'

class QueryExecutorTest < ActiveSupport::TestCase
  def setup
    QueryJob.const_set(:QueryExecutor , MongoQueryExecutor)
    Mongoid.master.drop_collection('query_results')
    MongoQueryExecutor.clean_js_libs
    MongoQueryExecutor.load_js_libs
  end

  def test_execute
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    q = Query.create(map: mf, reduce: rf)
    qe = MongoQueryExecutor.new(mf, rf, nil,q.id)

    results =  qe.execute
    assert_equal 213, results['M'].to_i
  end

  def test_execute_with_underscore
    mf = File.read('test/fixtures/map_reduce/map_with_underscore.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    q = Query.create(map: mf, reduce: rf)
    qe = MongoQueryExecutor.new(mf, rf, nil, q.id)

    results = qe.execute
    assert_equal 213, results['M'].to_i
  end

  def test_execute_with_all_male_query
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    q = Query.create(map: mf, reduce: rf)
    qe = MongoQueryExecutor.new(mf, rf,nil, q.id, {gender: "M"})

    results = qe.execute
    assert_equal 213, results['M'].to_i
    assert_equal nil, results['F']
  end

  def test_execute_with_birthdate_query
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    q = Query.create(map: mf, reduce: rf)

    # 739558907 = 18 years ago from June 8, 2011
    qe = MongoQueryExecutor.new(mf, rf, nil, q.id, {birthdate: {"$gt" => 739558907}})

    results =  qe.execute

    assert_equal 57, results['M'].to_i
    assert_equal 70, results['F'].to_i
  end

end
