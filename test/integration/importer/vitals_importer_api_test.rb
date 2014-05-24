require 'test_helper'

class VitalsImporterApiTest < ImporterApiTest
  def test_vitals_importing
    assert @context.eval('patient.vitalSigns().match({"LOINC": ["8302-2"]}).length != 0')
    assert @context.eval('patient.vitalSigns().match({"SNOMED-CT": ["50373000"]}).length != 0')
    assert_equal 'N', @context.eval('patient.vitalSigns()[0].interpretation().code()')
    assert_equal 'HITSP C80 Observation Status', @context.eval('patient.vitalSigns()[0].interpretation().codeSystemName()')
    assert_equal 177, @context.eval('patient.vitalSigns()[0].values()[0].scalar()')
    assert_equal 'cm', @context.eval('patient.vitalSigns()[0].values()[0].units()')
    assert_equal 1999, @context.eval('patient.vitalSigns()[0].date().getUTCFullYear()')
    assert_equal 10, @context.eval('patient.vitalSigns()[0].date().getUTCMonth()')
    assert_equal 14, @context.eval('patient.vitalSigns()[0].date().getUTCDate()')
  end
end

class E2EVitalsImporterApiTest < E2EImporterApiTest
  def test_e2e_vitals_importing
    #assert_equal 'theValue', @context.eval('e2e_patient.vitalSigns()')
    assert @context.eval('e2e_patient.vitalSigns().match({"LOINC": ["8480-6"]}).length != 0')
    assert @context.eval('e2e_patient.vitalSigns().match({"LOINC": ["3141-9"]}).length != 0')
    assert_nil @context.eval('e2e_patient.vitalSigns()[0].interpretation()')
    assert_equal 130, @context.eval('e2e_patient.vitalSigns()[0].values()[0].scalar()')
    assert_equal 'mm[Hg]', @context.eval('e2e_patient.vitalSigns()[0].values()[0].units()')
    assert_equal 2013, @context.eval('e2e_patient.vitalSigns()[0].date().getUTCFullYear()')
    assert_equal 8, @context.eval('e2e_patient.vitalSigns()[0].date().getUTCMonth()')
    assert_equal 25, @context.eval('e2e_patient.vitalSigns()[0].date().getUTCDate()')
  end
end