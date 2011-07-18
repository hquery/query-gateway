require 'test_helper'

class ImmunizationTest < ActiveSupport::TestCase
  def test_result_to_hash
    immunization = Importer::Immunization.new
    immunization.time = 1234
    immunization.add_code(1234, 'CVX')
    immunization.refusal = false
    
    h = immunization.to_hash
    
    assert_equal 1234, h['administeredDate']
    assert h['medicationInformation']['codedProducts']['CVX'].include? 1234
  end
end