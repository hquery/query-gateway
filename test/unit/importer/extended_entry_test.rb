require 'test_helper'

class SimpleEntry < Importer::ExtendedEntry
  extended_attributes :bacon_per_day
  extended_attributes :reference_range, :dose
end

class AnotherEnrty < Importer::ExtendedEntry
  extended_attributes :coffee_per_day
end

class ExtendedEntryTest < ActiveSupport::TestCase
  
  test "creating and hashing a simple entry" do
    se = SimpleEntry.new
    se.time = 1234
    se.add_code(1234, 'RxNorm')
    se.bacon_per_day = {'value' =>5, 'unit' => 'slices'}
    se.reference_range = '3 to 7 slices'
    se.dose = {'value' => 1, 'unit' => 'slice'}
    
    h = se.to_hash
    assert_equal 1234, h['time']
    assert_equal 'slices', h['baconPerDay']['unit']
    assert_equal '3 to 7 slices', h['referenceRange']
  end
  
  test "does not leak properties" do
    se = SimpleEntry.new
    assert ! se.respond_to?(:coffee_per_day)
    assert se.respond_to?(:bacon_per_day)
    
    ae = AnotherEnrty.new
    assert ae.respond_to?(:coffee_per_day)
    assert ! ae.respond_to?(:bacon_per_day)
  end
end