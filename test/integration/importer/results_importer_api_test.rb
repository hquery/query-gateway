require 'test_helper'

class ResultsImporterApiTest < ImporterApiTest
  def test_results_importing
    assert_equal '30313-1', @context.eval('patient.results()[0].type()[0].code()')
    assert_equal 'LOINC', @context.eval('patient.results()[0].type()[0].codeSystemName()')
    assert_equal 'N', @context.eval('patient.results()[0].interpretation().code()')
    assert_equal 'HITSP C80 Observation Status', @context.eval('patient.results()[0].interpretation().codeSystemName()')
    assert_equal '13.2', @context.eval('patient.results()[0].value()[\'scalar\']')
    assert_equal 'g/dl', @context.eval('patient.results()[0].value()[\'units\']')
    assert_equal 2000, @context.eval('patient.results()[0].date().getUTCFullYear()')
    assert_equal 2, @context.eval('patient.results()[0].date().getUTCMonth()')
    assert_equal 23, @context.eval('patient.results()[0].date().getUTCDate()')
  end
end