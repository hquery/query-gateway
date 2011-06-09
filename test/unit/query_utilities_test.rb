require 'test_helper'
require 'query_utilities'

class QueryUtilitiesTest < ActiveSupport::TestCase
  
  include QueryUtilities
  
  def test_parse_empty_json_to_hash
    assert_equal Hash.new, parse_json_to_hash(nil)
    assert_equal Hash.new, parse_json_to_hash('')
    assert_equal Hash.new, parse_json_to_hash('    ')
  end

  def test_parse_error_json_to_hash
    begin
      parse_json_to_hash("crap")
      assert false
    rescue
      assert true
    end
  end
  
  def test_parse_valid_json_to_hash
    correct_hash = {"gender" => "M"}
    assert_equal correct_hash, parse_json_to_hash('{"gender" : "M"}')
    assert_equal correct_hash, parse_json_to_hash('  {"gender" : "M"}  ')
    correct_hash = ({"birthdate" => {"$gt" => 739558907}})
    assert_equal correct_hash, parse_json_to_hash('{"birthdate" : {"$gt" : 739558907}}')
  end
  
  def test_convert_filter_to_mongo_query
    assert_equal nil, convert_filter_to_mongo_query(nil)
    assert_equal Hash.new, convert_filter_to_mongo_query(Hash.new)
    assert_equal ({"anything" => "anything"}), convert_filter_to_mongo_query({"anything" => "anything"})
  end
  
end