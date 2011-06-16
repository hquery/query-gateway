require 'test_helper'

class PatientApiTest < ActiveSupport::TestCase
  def setup
    patient_api = QueryExecutor.patient_api_javascript.to_s
    fixture_json = File.read('test/fixtures/patient/barry_berry.json')
    initialize_patient = 'var patient = new Patient(barry);'
    @context = ExecJS.compile(patient_api + "\n" + fixture_json + "\n" + initialize_patient)
  end
  
  def test_demographics
    assert_equal 'Barry', @context.eval('patient.given()')
    assert_equal 1962, @context.eval('patient.birthtime().getFullYear()')
  end
  
  def test_encounters
    assert_equal 2, @context.eval('patient.encounters().length')
    assert_equal '99201', @context.eval('patient.encounters()[0].type()[0].code')
    assert_equal 'CPT', @context.eval('patient.encounters()[0].type()[0].codeSystemName')
  end
end