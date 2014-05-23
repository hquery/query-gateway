require 'test_helper'

class ResultsImporterApiTest < ImporterApiTest
  def test_results_importing
    assert_equal '30313-1', @context.eval('patient.results()[0].type()[0].code()')
    assert_equal 'LOINC', @context.eval('patient.results()[0].type()[0].codeSystemName()')
    assert_equal 'N', @context.eval('patient.results()[0].interpretation().code()')
    assert_equal 'HITSP C80 Observation Status', @context.eval('patient.results()[0].interpretation().codeSystemName()')
    assert_equal 13.2, @context.eval('patient.results()[0].values()[0].scalar()')
    assert_equal 'g/dl', @context.eval('patient.results()[0].values()[0].units()')
    assert_equal 2000, @context.eval('patient.results()[0].date().getUTCFullYear()')
    assert_equal 2, @context.eval('patient.results()[0].date().getUTCMonth()')
    assert_equal 23, @context.eval('patient.results()[0].date().getUTCDate()')
  end
end

class E2EResultsImporterApiTest < E2EImporterApiTest
  def test_e2e_results_importing
    assert_equal '6690-2', @context.eval('e2e_patient.results()[0].type()[0].code()')
    assert_equal 'LOINC', @context.eval('e2e_patient.results()[0].type()[0].codeSystemName()')
    assert_equal 'N', @context.eval('e2e_patient.results()[0].interpretation().code()')
    assert_equal 'ObservationInterpretation', @context.eval('e2e_patient.results()[0].interpretation().codeSystemName()')
    assert_equal 8, @context.eval('e2e_patient.results()[0].values()[0].scalar()')
    assert_equal 'giga/L', @context.eval('e2e_patient.results()[0].values()[0].units()')
    assert_equal 2013, @context.eval('e2e_patient.results()[0].date().getUTCFullYear()')
    assert_equal 4, @context.eval('e2e_patient.results()[0].date().getUTCMonth()')
    assert_equal 31, @context.eval('e2e_patient.results()[0].date().getUTCDate()')
  end
end