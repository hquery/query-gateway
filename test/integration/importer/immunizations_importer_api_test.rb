require 'test_helper'

class ImmunizationsImporterApiTest < ImporterApiTest
  def test_imunizations_importing
    assert_equal 4, @context.eval('patient.immunizations().length')
    assert @context.eval('patient.immunizations().match({"CVX": ["111"]}).length != 0')
    assert @context.eval('patient.immunizations().match({"CVX": ["113"]}, null, null, true).length != 0')
    assert @context.eval('patient.immunizations().match({"CVX": ["09"]}, null, null, true).length != 0')
# TODO Need to update the patientapi to handle performer now that they are no longer embedded
#    assert_equal 'FirstName', @context.eval('patient.immunizations()[3].performer().person().given()')
#    assert_equal 'LastName', @context.eval('patient.immunizations()[3].performer().person().last()')
#    assert_equal 1, @context.eval('patient.immunizations()[3].performer().person().addresses().length')
#    assert_equal '100 Bureau Drive', @context.eval('patient.immunizations()[3].performer().person().addresses()[0].street()[0]')
#    assert_equal 'Gaithersburg', @context.eval('patient.immunizations()[3].performer().person().addresses()[0].city()')
#    assert_equal 'MD', @context.eval('patient.immunizations()[3].performer().person().addresses()[0].state()')
#    assert_equal '20899', @context.eval('patient.immunizations()[3].performer().person().addresses()[0].postalCode()')
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

class E2EImmunizationsImporterApiTest < E2EImporterApiTest
  def test_e2e_imunizations_importing
    assert_equal 3, @context.eval('e2e_patient.immunizations().length')
    assert @context.eval('e2e_patient.immunizations().match({"whoATC": ["J07CA01"]}).length != 0')
    assert @context.eval('e2e_patient.immunizations().match({"whoATC": ["J07AL02"]}, null, null, true).length != 0')
    assert @context.eval('e2e_patient.immunizations().match({"whoATC": ["J07BB01"]}, null, null, true).length != 0')
# TODO Need to update the patientapi to handle performer now that they are no longer embedded
#    assert_equal 'FirstName', @context.eval('e2e_patient.immunizations()[3].performer().person().given()')
#    assert_equal 'LastName', @context.eval('e2e_patient.immunizations()[3].performer().person().last()')
#    assert_equal 1, @context.eval('e2e_patient.immunizations()[3].performer().person().addresses().length')
#    assert_equal '100 Bureau Drive', @context.eval('e2e_patient.immunizations()[3].performer().person().addresses()[0].street()[0]')
#    assert_equal 'Gaithersburg', @context.eval('e2e_patient.immunizations()[3].performer().person().addresses()[0].city()')
#    assert_equal 'MD', @context.eval('e2e_patient.immunizations()[3].performer().person().addresses()[0].state()')
#    assert_equal '20899', @context.eval('e2e_patient.immunizations()[3].performer().person().addresses()[0].postalCode()')
    assert_equal nil, @context.eval('e2e_patient.immunizations()[2].refusalInd()')
    assert_equal false, @context.eval('e2e_patient.immunizations()[2].refusalReason().isPatObj()')
    assert_equal 2012, @context.eval('e2e_patient.immunizations()[0].startDate().getUTCFullYear()')
    assert_equal 8, @context.eval('e2e_patient.immunizations()[0].startDate().getUTCMonth()')
    assert_equal 1, @context.eval('e2e_patient.immunizations()[0].startDate().getUTCDate()')
    assert @context.eval('e2e_patient.immunizations()[0].includesCodeFrom({"whoATC": ["J07CA01"]})')
    assert @context.eval('e2e_patient.immunizations()[2].includesCodeFrom({"whoATC": ["J07AL02"]})')
    #TODO find out why these methods don't work (claims codeSystemName is undefined)
    #assert_equal 'xyz',    @context.eval('e2e_patient.immunizations()[0].medicationInformation().codedProduct()[0]')
    #assert_equal 'whoATC', @context.eval('e2e_patient.immunizations()[0].medicationInformation().codedProduct()[0].codeSystemName()')
    #assert_equal 'J07CA01', @context.eval('e2e_patient.immunizations()[0].medicationInformation().codedProduct()[0].code()')
    #assert_equal 'whoATC', @context.eval('e2e_patient.immunizations()[2].medicationInformation().codedProduct()[1].codeSystemName()')
    #assert_equal 'J07AL02', @context.eval('e2e_patient.immunizations()[2].medicationInformation().codedProduct()[1].code()')

  end
end


class E2EImmunizationsImporterApiTest2 < E2EImporterApiTest2
  def test_e2e_imunizations_importing_zarilla
    assert_equal 3, @context.eval('e2e_patient2.immunizations().length')
    assert @context.eval('e2e_patient2.immunizations().match({"Unknown": ["NA"]}).length != 0')
    assert @context.eval('e2e_patient2.immunizations().match({"Unknown": ["NA"]}, null, null, true).length != 0')
# TODO Need to update the patientapi to handle performer now that they are no longer embedded
#    assert_equal 'FirstName', @context.eval('e2e_patient2.immunizations()[3].performer().person().given()')
#    assert_equal 'LastName', @context.eval('e2e_patient2.immunizations()[3].performer().person().last()')
#    assert_equal 1, @context.eval('e2e_patient2.immunizations()[3].performer().person().addresses().length')
#    assert_equal '100 Bureau Drive', @context.eval('e2e_patient2.immunizations()[3].performer().person().addresses()[0].street()[0]')
#    assert_equal 'Gaithersburg', @context.eval('e2e_patient2.immunizations()[3].performer().person().addresses()[0].city()')
#    assert_equal 'MD', @context.eval('e2e_patient2.immunizations()[3].performer().person().addresses()[0].state()')
#    assert_equal '20899', @context.eval('e2e_patient2.immunizations()[3].performer().person().addresses()[0].postalCode()')
    assert_equal nil, @context.eval('e2e_patient2.immunizations()[2].refusalInd()')
    assert_equal false, @context.eval('e2e_patient2.immunizations()[2].refusalReason().isPatObj()')
    assert_equal 2012, @context.eval('e2e_patient2.immunizations()[0].date().getUTCFullYear()')
    assert_equal 3, @context.eval('e2e_patient2.immunizations()[0].date().getUTCMonth()')
    assert_equal 17, @context.eval('e2e_patient2.immunizations()[0].date().getUTCDate()')
    assert @context.eval('e2e_patient2.immunizations()[0].includesCodeFrom({"Unknown": ["NA"]})')
    assert_equal 'Varicella Zoster', @context.eval('e2e_patient2.immunizations()[2]["json"]["description"]')

  end
end