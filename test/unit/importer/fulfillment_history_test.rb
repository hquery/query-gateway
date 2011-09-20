require 'test_helper'

class FulfillmentHistoryTest < ActiveSupport::TestCase
  def test_result_to_hash
    fulfillment_history = Importer::FulfillmentHistory.new
    fulfillment_history.prescription_number = '2345'
    fulfillment_history.fill_number = 1
    
    h = fulfillment_history.to_hash
    
    assert_equal '2345', h['prescriptionNumber']
    assert_equal 1, h['fillNumber']
  end
end