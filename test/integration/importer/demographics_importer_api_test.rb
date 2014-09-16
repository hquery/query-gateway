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

class E2EDemographicsImporterApiTest < E2EImporterApiTest
  def test_e2e_demographics_importing
    assert_equal 'JOHN', @context.eval('e2e_patient.given()')
    assert_equal 'CLEESE', @context.eval('e2e_patient.last()')
    assert_equal 'M', @context.eval('e2e_patient.gender()')
    assert_equal 1940, @context.eval('e2e_patient.birthtime().getUTCFullYear()')
    # JS numbers months starting with 0, so 8 below is actually September as expected
    assert_equal 8, @context.eval('e2e_patient.birthtime().getUTCMonth()')
    assert_equal 25, @context.eval('e2e_patient.birthtime().getUTCDate()')
    assert_equal 69, @context.eval('Math.floor(e2e_patient.age(sampleDate))')
    # illustrate how to retrieve primary key of demographics table in EMR instance used to populate records collection
    assert_equal "1", @context.eval('e2e_patient["json"]["emr_demographics_primary_key"]')
  end
end