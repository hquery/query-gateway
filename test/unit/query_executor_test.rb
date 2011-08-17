require 'test_helper'

class QueryExecutorTest < ActiveSupport::TestCase
  def setup
    Mongoid.master.drop_collection('query_results')
    QueryUtilities.clean_js_libs
    QueryUtilities.load_js_libs
  end

  def test_execute
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    q = Query.create(map: mf, reduce: rf)
    qe = QueryExecutor.new(mf, rf, q.id)
    qe.execute

    results = q.result
    assert_equal 231, results['M']
  end

  def test_execute_with_underscore
    mf = File.read('test/fixtures/map_reduce/map_with_underscore.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    q = Query.create(map: mf, reduce: rf)
    qe = QueryExecutor.new(mf, rf, q.id)
    qe.execute

    results = q.result
    assert_equal 231, results['M']
  end

  def test_execute_with_all_male_query
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    q = Query.create(map: mf, reduce: rf)
    qe = QueryExecutor.new(mf, rf, q.id, {gender: "M"})
    qe.execute

    results = q.result

    assert_equal 231, results['M']
    assert_equal nil, results['F']
  end

  def test_execute_with_birthdate_query
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    q = Query.create(map: mf, reduce: rf)

    # 739558907 = 18 years ago from June 8, 2011
    qe = QueryExecutor.new(mf, rf, q.id, {birthdate: {"$gt" => 739558907}})
    qe.execute

    results = q.result

    assert_equal 62, results['M']
    assert_equal 57, results['F']
  end

end
