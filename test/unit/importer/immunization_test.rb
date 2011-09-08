require 'test_helper'

class ImmunizationTest < ActiveSupport::TestCase
  test 'generating a hash for a plain immunization' do
    immunization = Importer::Immunization.new
    immunization.time = 1234
    immunization.add_code(1234, 'CVX')
    immunization.refusal_ind = false
    
    h = immunization.to_hash
    
    assert_equal 1234, h['administeredDate']
    assert h['codes']['CVX'].include? 1234
  end
  
  test 'generating a hash for a refused immunization' do
    immunization = Importer::Immunization.new
    immunization.time = 1234
    immunization.add_code(1234, 'CVX')
    immunization.refusal_ind = true
    immunization.refusal_reason = {'code' => 'PATOBJ', 'codeSystem' => 'HL7 No Immunization Reason'}
    
    h = immunization.to_hash
    
    assert h['refusalInd']
    assert_equal 'PATOBJ', h['refusalReason']['code']
  end
end