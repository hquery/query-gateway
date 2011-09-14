require 'test_helper'

class VitalSignImporterTest < ActiveSupport::TestCase
  def test_vital_sign_importing
    doc = Nokogiri::XML(File.new('test/fixtures/NISTExampleC32.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = QME::Importer::PatientImporter.instance
    patient = pi.create_c32_hash(doc)
    
    vital_sign = patient[:vital_signs][0]
    
    assert_equal 'N', vital_sign.interpretation['code']
    assert_equal "177", vital_sign.value[:scalar]
    assert_equal "cm", vital_sign.value[:units]
    assert_equal 'HITSP C80 Observation Status', vital_sign.interpretation['codeSystem']
    assert_equal 'completed', vital_sign.status
  end
end