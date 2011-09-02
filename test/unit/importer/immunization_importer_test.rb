require 'test_helper'

class ImmunizationImporterTest < ActiveSupport::TestCase
  def test_immunization_importing
    doc = Nokogiri::XML(File.new('test/fixtures/NISTExampleC32.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = QME::Importer::PatientImporter.instance
    patient = pi.create_c32_hash(doc)
    
    immunization = patient[:immunizations][0]
    assert immunization.codes['CVX'].include? '88'
    assert immunization.codes['CVX'].include? '111'
    
    immunization = patient[:immunizations][1]
    assert_equal false, immunization.refusal
    
    immunization = patient[:immunizations][3]
    assert_equal true, immunization.refusal
    assert_equal 'PATOBJ', immunization.refusal_reason['code']
    assert_equal 'FirstName', immunization.performer['person']['given']
    assert_equal '100 Bureau Drive', immunization.performer['person']['addresses'].first['streetAddress']
  end
end