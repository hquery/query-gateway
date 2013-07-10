require 'test_helper'

class QueryUtilitesTest < ActiveSupport::TestCase

  test "Stringification" do
    key = Moped::BSON::Document.new
    key['a'] = 'b'
    key['c'] = 'd'
    str = QueryUtilities.stringify_key(key)
    assert_equal 'a_b_c_d', str
    key = ['a', 'b', 'c', 'd']
    str = QueryUtilities.stringify_key(key)
    assert_equal 'a_b_c_d', str
  end

end
