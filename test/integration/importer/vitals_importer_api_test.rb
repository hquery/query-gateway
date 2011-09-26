require 'test_helper'

class VitalsImporterApiTest < ImporterApiTest
  def test_vitals_importing
    assert @context.eval('patient.vitalSigns().match({"LOINC": ["8302-2"]}).length != 0')
    assert @context.eval('patient.vitalSigns().match({"SNOMED-CT": ["50373000"]}).length != 0')
    assert_equal 'N', @context.eval('patient.vitalSigns()[0].interpretation().code()')
    assert_equal 'HITSP C80 Observation Status', @context.eval('patient.vitalSigns()[0].interpretation().codeSystemName()')
    assert_equal '177', @context.eval('patient.vitalSigns()[0].value()[\'scalar\']')
    assert_equal 'cm', @context.eval('patient.vitalSigns()[0].value()[\'units\']')
    assert_equal 'completed', @context.eval('patient.vitalSigns()[0].status()')    
    assert_equal 1999, @context.eval('patient.vitalSigns()[0].date().getUTCFullYear()')
    assert_equal 10, @context.eval('patient.vitalSigns()[0].date().getUTCMonth()')
    assert_equal 14, @context.eval('patient.vitalSigns()[0].date().getUTCDate()')
  end
end