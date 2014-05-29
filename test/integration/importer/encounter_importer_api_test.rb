require 'test_helper'

class EncounterImporterApiTest < ImporterApiTest
  def test_encounter_importing
    #assert_equal 'xyz', @context.eval('patient.encounters()')
    assert_equal 1, @context.eval('patient.encounters().length')
    assert @context.eval('patient.encounters().match({"CPT": ["99241"]}).length != 0')
# TODO Need to update the patientapi to handle performer now that they are no longer embedded
#    assert_equal 'Dr. Kildare', @context.eval('patient.encounters()[0].performer().person().name()')
    #assert_equal nil, @context.eval('patient.encounters()[0].performer().person()')
    assert_equal 'Good Health Clinic', @context.eval('patient.encounters()[0].facility().name()')
    assert @context.eval('patient.encounters()[0].reasonForVisit().includesCodeFrom({"SNOMED-CT": ["308292007"]})')
    assert @context.eval('patient.encounters()[0].admitType().includedIn({"CPT": ["xyzzy"]})')
    assert_equal 2000, @context.eval('patient.encounters()[0].date().getUTCFullYear()')
    assert_equal 3, @context.eval('patient.encounters()[0].date().getUTCMonth()')
    assert_equal 7, @context.eval('patient.encounters()[0].date().getUTCDate()')
  end
end

class E2EEncounterImporterApiTest < E2EImporterApiTest
  def test_e2e_encounter_importing
    assert_equal 2, @context.eval('e2e_patient.encounters().length')
    #TODO provide a nicer way to get performer information
    #TODO consider reverting encounter provider to a hash field as it existed when patientapi was last maintained
    assert_equal 'doctor', @context.eval('e2e_patient.encounters()[0].performer()["json"]["given_name"]')
    assert_equal 'oscardoc', @context.eval('e2e_patient.encounters()[0].performer()["json"]["family_name"]')
    assert_equal '999998', @context.eval('e2e_patient.encounters()[0].performer()["json"]["npi"]')
    #TODO resolve why time has been resolved to midnight plus 7 hours (seems to be UTC midnight rather than time actually specified)
    assert_equal Time.gm(2013,9,26,7,0,0).to_i, @context.eval('e2e_patient.encounters()[0].performer()["json"]["start"]')
    assert_nil @context.eval('e2e_patient.encounters()[0].facility().name()')
    assert @context.eval('e2e_patient.encounters()[0].reasonForVisit().includesCodeFrom({"ObservationType-CA-Pending": ["REASON"]})')
    assert_nil @context.eval('e2e_patient.encounters()[0].admitType()')
    assert_equal 2013, @context.eval('e2e_patient.encounters()[0].date().getUTCFullYear()')
    # Note month count is 0 through 11 so 8 is actually September.
    assert_equal 8, @context.eval('e2e_patient.encounters()[0].date().getUTCMonth()')
    assert_equal 26, @context.eval('e2e_patient.encounters()[0].date().getUTCDate()')
  end
end