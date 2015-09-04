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
    assert_equal 6, @context.eval('e2e_patient.encounters().length')
    #TODO provide a nicer way to get performer information
    #TODO consider reverting encounter provider to a hash field as it existed when patientapi was last maintained
    assert_equal '', @context.eval('e2e_patient.encounters()[0].performer()["json"]["given_name"]')
    family_name=@context.eval('e2e_patient.encounters()[0].performer()["json"]["family_name"]')
    assert_equal 'qbGJGxVjhsCx/JR42Bd7tX4nbBYNgR/TehN7gQ==', family_name
    assert_equal family_name, @context.eval('e2e_patient.encounters()[0].performer()["json"]["npi"]')
    #assert_equal 'doctor', @context.eval('e2e_patient.encounters()[0].performer()["json"]["given_name"]')
    #assert_equal 'oscardoc', @context.eval('e2e_patient.encounters()[0].performer()["json"]["family_name"]')
    #assert_equal 'cpsid', @context.eval('e2e_patient.encounters()[0].performer()["json"]["npi"]')
    #Note that provider time resolved to midnight plus 7 hours (i.e., UTC midnight) before DateTime was substituted for Date in HDS E2E provider importer
    #assert_equal 'xyz', @context.eval('e2e_patient.encounters()[0]')
    assert_equal Time.gm(2013,9,25,15,50,0).to_i, @context.eval('e2e_patient.encounters()[0].performer()["json"]["start"]')
    assert_equal Time.gm(2013,9,25,15,50,0).to_i, @context.eval('e2e_patient.encounters()[0]["json"]["start_time"]')
    assert_equal Time.gm(2013,9,25,15,50,0).to_i, @context.eval('e2e_patient.encounters()[0].startDate()').to_i
    assert_nil @context.eval('e2e_patient.encounters()[0].facility()')
    assert @context.eval('e2e_patient.encounters()[0].reasonForVisit().includesCodeFrom({"ObservationType-CA-Pending": ["REASON"]})')
    assert_nil @context.eval('e2e_patient.encounters()[0].admitType()')
    assert_equal 2013, @context.eval('e2e_patient.encounters()[0].startDate().getUTCFullYear()')
    # Note month count is 0 through 11 so 8 is actually September.
    assert_equal 8, @context.eval('e2e_patient.encounters()[0].startDate().getUTCMonth()')
    assert_equal 25, @context.eval('e2e_patient.encounters()[0].startDate().getUTCDate()')
  end
end

class E2EEncounterImporterApiTest2 < E2EImporterApiTest2
  def test_e2e_encounter_importing_zarilla
    assert_equal 3, @context.eval('e2e_patient2.encounters().length')
    #TODO provide a nicer way to get performer information
    #TODO consider reverting encounter provider to a hash field as it existed when patientapi was last maintained
    assert_equal '', @context.eval('e2e_patient2.encounters()[0].performer()["json"]["given_name"]')
    family_name0=@context.eval('e2e_patient2.encounters()[0].performer()["json"]["family_name"]')
    family_name1=@context.eval('e2e_patient2.encounters()[1].performer()["json"]["family_name"]')
    family_name2=@context.eval('e2e_patient2.encounters()[2].performer()["json"]["family_name"]')
    assert_equal '723CDj1qKtsyu1RWPnBZZ4xV+24qZMoEYh/BuQ==', family_name0
    assert_equal '723CDj1qKtsyu1RWPnBZZ4xV+24qZMoEYh/BuQ==', family_name1
    assert_equal 'uEFPPUFw3c7CDbHqEc96WJlAffuarPOnsUFbnw==', family_name2
    assert_equal family_name0, @context.eval('e2e_patient2.encounters()[0].performer()["json"]["npi"]')
    #Note that provider time resolved to midnight plus 7 hours (i.e., UTC midnight) before DateTime was substituted for Date in HDS E2E provider importer
    #assert_equal 'xyz', @context.eval('e2e_patient2.encounters()[0]')
    assert_equal Time.gm(2012,6,12,10,0,0).to_i, @context.eval('e2e_patient2.encounters()[0].performer()["json"]["start"]')
    assert_equal Time.gm(2012,6,12,10,0,0).to_i, @context.eval('e2e_patient2.encounters()[0]["json"]["start_time"]')
    assert_equal Time.gm(2012,6,12,10,0,0).to_i, @context.eval('e2e_patient2.encounters()[0].startDate()').to_i
    assert_nil @context.eval('e2e_patient2.encounters()[0].facility()')
    assert @context.eval('e2e_patient2.encounters()[0].reasonForVisit().includesCodeFrom({"ObservationType-CA-Pending": ["REASON"]})')
    assert_nil @context.eval('e2e_patient2.encounters()[0].admitType()')
    assert_equal 2012, @context.eval('e2e_patient2.encounters()[0].startDate().getUTCFullYear()')
    # Note month count is 0 through 11 so 8 is actually September.
    assert_equal 5, @context.eval('e2e_patient2.encounters()[0].startDate().getUTCMonth()')
    assert_equal 12, @context.eval('e2e_patient2.encounters()[0].startDate().getUTCDate()')
  end
end
