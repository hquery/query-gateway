require 'test_helper'

class OrderInformationTest < ActiveSupport::TestCase
  def test_result_to_hash
    order_information = Importer::OrderInformation.new
    order_information.fills = 1
    order_information.order_number = '1234'
    
    h = order_information.to_hash
    
    assert_equal '1234', h['orderNumber']
    assert_equal 1, h['fills']
  end
end