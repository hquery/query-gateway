require 'test_helper'

class QueryExecutorTest < ActiveSupport::TestCase
  
  def setup   
    #Mongoid.master.drop_collection('query_results')
    db = Mongoid.default_session
    #db.drop_collection('query_results')
    db[:query_results].drop
    if defined?(QueryExecutor.test_setup)
      QueryExecutor.test_setup
    end

  end

  def test_execute
    mf = File.read('test/fixtures/map_reduce/simple_map.js')
    rf = File.read('test/fixtures/map_reduce/simple_reduce.js')
    q = Query.create(map: mf, reduce: rf)
    qe = QueryJob::QueryExecutor.new('js', mf, rf, nil,q.id.to_s)

    results =  qe.execute
    assert_equal 213, results['M'].to_i
  end
  
  def test_handwritten_hqmf_execute
    hqmf_contents = File.open('test/fixtures/NQF59New.xml').read
    doc = HQMF::Parser.parse(hqmf_contents, HQMF::Parser::HQMF_VERSION_2)
    map_reduce = HQMF2JS::Converter.generate_map_reduce(doc)
    map = map_reduce[:map]
    reduce = map_reduce[:reduce]
    functions = map_reduce[:functions]
    query = Query.create(:format => 'hqmf', :map => map, :reduce => reduce, :functions => functions)
    query_executor = QueryJob::QueryExecutor.new('hqmf', map, reduce, functions, query.id.to_s)
    results = query_executor.execute
    assert_equal 269, results['ipp'].to_i
    assert_equal 46, results['denom'].to_i
    assert_equal 16, results['numer'].to_i
    assert_equal 30, results['antinum'].to_i
  end

end
