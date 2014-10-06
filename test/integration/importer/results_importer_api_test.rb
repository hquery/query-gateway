require 'test_helper'

class ResultsImporterApiTest < ImporterApiTest
  def test_results_importing
    assert_equal 6, @context.eval('patient.results().length')
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
    assert_equal 28, @context.eval('e2e_patient.results().length')
    assert_equal '6690-2', @context.eval('e2e_patient.results()[0].type()[0].code()')
    assert_equal 'pCLOCD', @context.eval('e2e_patient.results()[0].type()[0].codeSystemName()')
    assert_equal 'N', @context.eval('e2e_patient.results()[0].interpretation().code()')
    assert_equal 'ObservationInterpretation', @context.eval('e2e_patient.results()[0].interpretation().codeSystemName()')
    assert_equal 8, @context.eval('e2e_patient.results()[0].values()[0].scalar()')
    assert_equal 'giga/L', @context.eval('e2e_patient.results()[0].values()[0].units()')
    assert_equal 2013, @context.eval('e2e_patient.results()[0].startDate().getUTCFullYear()')
    assert_equal 4, @context.eval('e2e_patient.results()[0].startDate().getUTCMonth()')
    assert_equal 31, @context.eval('e2e_patient.results()[0].startDate().getUTCDate()')
  end
end


class E2EResultsImporterApiTest2 < E2EImporterApiTest2
  def test_e2e_results_importing_zarilla
    #HDS testing reports 59 results but only 58 are seen here, presumably because of the one
    #nullFlavor lab result observed.
    assert_equal 58, @context.eval('e2e_patient2.results().length')
    assert_equal '14771-0', @context.eval('e2e_patient2.results()[15].type()[0].code()')
    assert_equal 'pCLOCD', @context.eval('e2e_patient2.results()[15].type()[0].codeSystemName()')
    assert_equal 'N', @context.eval('e2e_patient2.results()[15].interpretation().code()')
    assert_equal 'HITSP C80 Observation Status', @context.eval('e2e_patient2.results()[15].interpretation().codeSystemName()')
    assert_equal 0, @context.eval('e2e_patient2.results()[15].values().length')
    assert_equal '4.8 mmol/L', @context.eval('e2e_patient2.results()[15]["json"]["free_text"]')
    assert_equal Time.gm(2012,3,12,17,50,6), @context.eval('e2e_patient2.results()[15].startDate()')
    assert_equal 2012, @context.eval('e2e_patient2.results()[15].startDate().getUTCFullYear()')
    assert_equal 2, @context.eval('e2e_patient2.results()[15].startDate().getUTCMonth()')
    assert_equal 12, @context.eval('e2e_patient2.results()[15].startDate().getUTCDate()')
  end
end
