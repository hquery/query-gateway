require 'test_helper'

class ProcedureImporterApiTest < ImporterApiTest
  def test_procedure_importing
    assert_equal '52734007', @context.eval('patient.procedures()[0].type()[0].code()')
    assert_equal 'SNOMED-CT', @context.eval('patient.procedures()[0].type()[0].codeSystemName()')
    assert_equal nil, @context.eval('patient.procedures()[0].performer()')
    assert_equal '1234567', @context.eval('patient.procedures()[0].site().code()')
    assert_equal 'SNOMED-CT', @context.eval('patient.procedures()[0].site().codeSystemName()')
  end
end