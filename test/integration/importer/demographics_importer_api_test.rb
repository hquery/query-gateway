require 'test_helper'

class DemographicsImporterApiTest < ImporterApiTest
  def test_demographics_importing
    assert_equal 'FirstName', @context.eval('patient.given()')
    assert_equal 'LastName', @context.eval('patient.last()')
    assert_equal 'F', @context.eval('patient.gender()')
    assert_equal 1984, @context.eval('patient.birthtime().getUTCFullYear()')
    # JS numbers months starting with 0, so 6 below is actually July as expected
    assert_equal 6, @context.eval('patient.birthtime().getUTCMonth()')
    assert_equal 4, @context.eval('patient.birthtime().getUTCDate()')
    assert_equal 25, @context.eval('Math.floor(patient.age(sampleDate))')
  end
end