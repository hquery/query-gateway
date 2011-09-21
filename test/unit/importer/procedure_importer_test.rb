require 'test_helper'

class ProcedureImporterTest < ActiveSupport::TestCase
  def test_procedure_importing
    doc = Nokogiri::XML(File.new('test/fixtures/NISTExampleC32.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = QME::Importer::PatientImporter.instance
    patient = pi.create_c32_hash(doc)
    
    procedure = patient[:procedures][0]
    assert procedure.codes['SNOMED-CT'].include? '52734007'
    assert_equal procedure.performer['person']['name'], 'Dr. Kildare'
    assert_equal procedure.site['code'], "1234567"
    assert_equal procedure.site['codeSystem'], "SNOMED-CT"
  end
end