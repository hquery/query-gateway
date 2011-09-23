require 'test_helper'

class ImmunizationsImporterApiTest < ImporterApiTest
  def test_encounter_importing
    assert_equal 4, @context.eval('patient.immunizations().length')
    assert @context.eval('patient.immunizations().match({"CVX": ["111"]}).length != 0')
    assert @context.eval('patient.immunizations().match({"CVX": ["113"]}).length != 0')
    assert @context.eval('patient.immunizations().match({"CVX": ["09"]}).length != 0')
    assert_equal 'FirstName', @context.eval('patient.immunizations()[3].performer().person().given()')
    assert_equal 'LastName', @context.eval('patient.immunizations()[3].performer().person().last()')
    assert_equal 1, @context.eval('patient.immunizations()[3].performer().person().addresses().length')
    assert_equal '100 Bureau Drive', @context.eval('patient.immunizations()[3].performer().person().addresses()[0].street()[0]')
    assert_equal 'Gaithersburg', @context.eval('patient.immunizations()[3].performer().person().addresses()[0].city()')
    assert_equal 'MD', @context.eval('patient.immunizations()[3].performer().person().addresses()[0].state()')
    assert_equal '20899', @context.eval('patient.immunizations()[3].performer().person().addresses()[0].postalCode()')
    assert @context.eval('patient.immunizations()[3].refusalInd()')
    assert @context.eval('patient.immunizations()[3].refusalReason().isPatObj()')
    assert_equal 1997, @context.eval('patient.immunizations()[3].date().getUTCFullYear()')
    assert_equal 7, @context.eval('patient.immunizations()[3].date().getUTCMonth()')
    assert_equal 15, @context.eval('patient.immunizations()[3].date().getUTCDate()')
    assert @context.eval('patient.immunizations()[3].includesCodeFrom({"CVX": ["113"]})')
    assert @context.eval('patient.immunizations()[3].includesCodeFrom({"CVX": ["09"]})')
    assert_equal 'CVX', @context.eval('patient.immunizations()[3].medicationInformation().codedProduct()[0].codeSystemName()')
    assert_equal '09', @context.eval('patient.immunizations()[3].medicationInformation().codedProduct()[0].code()')
    assert_equal 'CVX', @context.eval('patient.immunizations()[3].medicationInformation().codedProduct()[1].codeSystemName()')
    assert_equal '113', @context.eval('patient.immunizations()[3].medicationInformation().codedProduct()[1].code()')
  end
end