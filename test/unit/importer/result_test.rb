require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  def test_result_to_hash
    result = Importer::Result.new
    result.time = 1234
    result.add_code(1234, 'RxNorm')
    result.interpretation_code = 'N'
    result.interpretation_code_system_name = "HITSP C80 Observation Status"
    
    h = result.to_hash
    
    assert_equal 1234, h['time']
    assert_equal 'N', h['interpretation']['code']
  end
end