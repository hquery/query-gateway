require 'test_helper'

class EncounterImporterTest < ActiveSupport::TestCase
  def test_encounter_importing
    doc = Nokogiri::XML(File.new('test/fixtures/NISTExampleC32.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = QME::Importer::PatientImporter.instance
    patient = pi.create_c32_hash(doc)
    
    encounter = patient[:encounters][0]
    assert encounter.codes['CPT'].include? '99241'
    
  end
end