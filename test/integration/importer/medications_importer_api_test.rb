require 'test_helper'

class MedicationsImporterApiTest < ImporterApiTest
  def test_medications_importing
    assert @context.eval('patient.medications().match({"RxNorm": ["307782"]}).length != 0')
    assert_equal 2, @context.eval('patient.medications()[0].dose().value()')
    assert_equal nil, @context.eval('patient.medications()[0].dose().unit()')
    assert_equal 2005, @context.eval('patient.medications()[0].timeStamp().getUTCFullYear()')
    assert_equal 0, @context.eval('patient.medications()[0].timeStamp().getUTCMonth()')
    assert_equal 1, @context.eval('patient.medications()[0].timeStamp().getUTCDate()')
    assert_equal 6, @context.eval('patient.medications()[0].administrationTiming().period().value()')
    assert_equal 'h', @context.eval('patient.medications()[0].administrationTiming().period().unit()')
    assert_equal nil, @context.eval('patient.medications()[0].administrationTiming().institutionSpecified()')
    assert_equal '73639000', @context.eval('patient.medications()[0].typeOfMedication().code()')
    assert_equal 'SNOMED-CT', @context.eval('patient.medications()[0].typeOfMedication().codeSystemName()')
    assert_equal true, @context.eval('patient.medications()[0].typeOfMedication().isPrescription()')
    assert_equal false, @context.eval('patient.medications()[0].typeOfMedication().isOverTheCounter()')
    assert_equal 'IPINHL', @context.eval('patient.medications()[0].route().code()')
    assert_equal 'Unknown', @context.eval('patient.medications()[0].route().codeSystemName()')
    assert_equal '127945006', @context.eval('patient.medications()[0].site().code()')
    assert_equal 'SNOMED-CT', @context.eval('patient.medications()[0].site().codeSystemName()')
    assert_equal '415215001', @context.eval('patient.medications()[0].productForm().code()')
    assert_equal 'NCI Thesaurus', @context.eval('patient.medications()[0].productForm().codeSystemName()')
    assert_equal 'DrugVehicleCode', @context.eval('patient.medications()[0].vehicle().code()')
    assert_equal 'SNOMED-CT', @context.eval('patient.medications()[0].vehicle().codeSystemName()')
    assert_equal '334980009', @context.eval('patient.medications()[0].deliveryMethod().code()')
    assert_equal 'SNOMED-CT', @context.eval('patient.medications()[0].deliveryMethod().codeSystemName()')
    assert_equal 5, @context.eval('patient.medications()[0].doseRestriction().numerator().value()')
    assert_equal nil, @context.eval('patient.medications()[0].doseRestriction().numerator().unit()')
    assert_equal 10, @context.eval('patient.medications()[0].doseRestriction().denominator().value()')
    assert_equal nil, @context.eval('patient.medications()[0].doseRestriction().denominator().unit()')
    assert_equal 1, @context.eval('patient.medications()[0].fulfillmentHistory().length')
    assert_equal "eleventeen", @context.eval('patient.medications()[0].fulfillmentHistory()[0].prescriptionNumber()')
    assert_equal 2011, @context.eval('patient.medications()[0].fulfillmentHistory()[0].dispenseDate().getUTCFullYear()')
    assert_equal 8, @context.eval('patient.medications()[0].fulfillmentHistory()[0].dispenseDate().getUTCMonth()')
    assert_equal 20, @context.eval('patient.medications()[0].fulfillmentHistory()[0].dispenseDate().getUTCDate()')
    assert_equal 30, @context.eval('patient.medications()[0].fulfillmentHistory()[0].quantityDispensed().value()')
    assert_equal nil, @context.eval('patient.medications()[0].fulfillmentHistory()[0].quantityDispensed().unit()')
    assert_equal 4, @context.eval('patient.medications()[0].fulfillmentHistory()[0].fillNumber()')
  end
end


class E2EMedicationsImporterApiTest < E2EImporterApiTest
  def test_e2e_medications_importing
    #assert_equal 3, @context.eval('e2e_patient.medications().length')
    #assert_equal "xyz", @context.eval('e2e_patient.medications()')
  end
end