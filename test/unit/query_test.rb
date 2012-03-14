require 'test_helper'

class QueryTest < ActiveSupport::TestCase
  setup do
    dump_database
  end
  
  test "Still get last query update before any queries are added" do
    t = Query.last_query_update
    assert t
    assert_equal 2011, t.year
  end

  test "Can see if they have been updated" do
    q = Query.new(:map => 'foo', :reduce => 'bar')
    q.save
    assert !q.has_been_updated?
    sleep 1 # Needed because timestamps are at second resolution
    q.reduce = 'splat'
    q.save
    assert q.has_been_updated?
  end
  
  test "Can convert a JSON string into a hash" do
    json = '{"gender": "M", "last": "Smith"}'
    q = Query.new
    q.filter_from_json_string(json)
    assert_equal 'M', q.filter['gender']
    assert_equal 'Smith', q.filter['last']
  end
end
