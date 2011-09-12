require 'test_helper'

class MedicationImporterTest < ActiveSupport::TestCase
  def test_medication_importing
    doc = Nokogiri::XML(File.new('test/fixtures/NISTExampleC32.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = QME::Importer::PatientImporter.instance
    patient = pi.create_c32_hash(doc)
    
    medication = patient[:medications][0]
    assert medication.codes['RxNorm'].include? '307782'
    assert_equal 6, medication.administration_timing['period']['value']
    assert_equal 'IPINHL', medication.route['code']
    assert_equal 2, medication.dose['value']
  end
end